module Dock
  module Warehouse
    class CleanJob < JobBase

      attr_accessor :job_id,:delete_buffer,:job_type,:time_field,:data_source,
      :data_tables,:keep_time,:tag,:expiration_time

      def data_source= source_name
        @data_source = Dock::Warehouse::DataSource.new(source_name)
      end

      def data_source
        @data_source ||= nil
      end

      def perform
        prepare
        clean
      end

      private
      def prepare
        init_data_tables
        print_job_info(self)
      end

      def init_data_tables
        self.data_tables = data_tables.split(',')
      end

      def clean
        data_tables.each do |table_name|
          expiration = Time.now.ago(eval keep_time).utc.beginning_of_day.to_s(:db)
          logger.info "Job ID: #{job_id}, Start cleanup the table #{table_name}, the expiration time is #{expiration} ."
          unless time_field.nil?
            delete_sql = <<-SQL
            DELETE FROM #{table_name}
            WHERE #{time_field} < '#{expiration}'
            LIMIT #{delete_buffer}
            SQL

            select_sql = <<-SQL
            SELECT count(1) FROM #{table_name}
            WHERE #{time_field} < '#{expiration}'
            SQL

            delete_times = (exec_sql(data_source, select_sql).first.first / buffer) + 1
            while (delete_times > 0)
              exec_sql(data_source, delete_sql)
              delete_times = delete_times - 1
              logger.info "Job ID: #{job_id}, Still be executed #{delete_times} times."
            end
          end
        end
      end

    end
  end
end
