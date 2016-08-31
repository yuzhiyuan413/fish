module Dock
  module Warehouse
    class EtlJob < JobBase

      attr_accessor :job_id, :tag, :extract_source, :extract_table,
      :extract_fields, :extract_clause, :extract_dir, :extract_file_path,
      :load_source, :load_table, :load_table_engine, :load_type, :load_dir,
      :load_file_path, :delimiter, :hdfs_backup, :increment_field,
      :increment_ident, :job_type, :load_fields, :extract_ssh_user,
      :extract_ssh_port

      def extract_source= source_name
        @extract_source = Dock::Warehouse::DataSource.new(source_name)
      end

      def load_source= source_name
        @load_source = Dock::Warehouse::DataSource.new(source_name)
      end

      def extract_source
        @extract_source ||= nil
      end

      def load_source
        @load_source ||= nil
      end

      def perform
        prepare
        extract_csv(self)
        transfer_csv
        load_csv(self)
        clean_tmp_file
      end

      private
      # Prepare for job
      def prepare
        truncate_load_table
        init_increment_ident
        init_extract_load_fields
        init_load_table_engine
        init_extract_load_file_path
        print_job_info(self)
      end

      ## Initialize the max value of the extract ident.
      def init_increment_ident
        sql = "select max(#{increment_field}) as increment_ident from #{load_table} "
        result = exec_sql(load_source, sql)
        self.increment_ident = result.first.first.to_i
      end

      def init_extract_load_fields
        if extract_fields.eql? '*'
          result = exec_sql(load_source, "desc #{load_table}")
          self.extract_fields = result.collect{|x| "`#{x.first}`"}.join(',')
          self.load_fields = ''
        else
          self.load_fields = extract_fields
        end
      end

      def init_load_table_engine
        self.load_table_engine = get_table_engine(load_source, load_table)
      end

      def init_extract_load_file_path
        self.load_file_path = "#{load_dir}/#{tag}_#{extract_table}_id_#{increment_ident}.csv"
        self.extract_file_path = "#{extract_dir}/#{tag}_#{extract_table}_id_#{increment_ident}.csv"
      end

      def ssh_host_string
        "#{extract_ssh_user}@#{extract_source.host}:#{extract_ssh_port}"
      end

      def clean_tmp_file
        ssh_rm(ssh_host_string, self.extract_file_path)
        ssh_rm(:local, self.load_file_path)
      end

      def transfer_csv
        ssh_download!(ssh_host_string,self.extract_file_path, self.load_file_path)
      end

      def truncate_load_table
        truncate_table(load_source, load_table) if load_type.eql?('truncate')
      end
    end
  end
end
