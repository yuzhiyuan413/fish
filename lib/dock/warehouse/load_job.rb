module Dock
  module Warehouse
    class LoadJob < JobBase

      attr_accessor :load_type,:delimiter,:hdfs_backup,:job_type,:job_id,
      :tmp_dir,:load_file_path,:hdfs_file_path,:load_source,:load_table,:tag,
      :webhdfs_host,:webhdfs_port,:hdfs_file_dir,:hdfs_file_name,:load_table_engine

      def load_source= source_name
        @load_source = Dock::Warehouse::DataSource.new(source_name)
      end

      def load_source
        @load_source ||= nil
      end

      def perform
        prepare
        hdfs_copy_to_local
        load_csv(self)
        clean_tmp_file
      end

      private
      def prepare
        truncate_load_table
        init_hdfs_load_file_path
        init_load_table_engine
        print_job_info(self)
      end

      def init_hdfs_load_file_path
        self.hdfs_file_dir = parse_ruby_exp(hdfs_file_dir)
        self.hdfs_file_name = parse_ruby_exp(hdfs_file_name)
        self.load_file_path = "#{tmp_dir}/#{tag}_#{load_table}_#{hdfs_file_name}.csv"
        self.hdfs_file_path = "#{hdfs_file_dir}/#{hdfs_file_name}"
      end

      def init_load_table_engine
        self.load_table_engine = get_table_engine(load_source, load_table)
      end

      def hdfs_copy_to_local
        WebHDFS::FileUtils.set_server(webhdfs_host, webhdfs_port)
        WebHDFS::FileUtils.copy_to_local(hdfs_file_path, load_file_path)
      end

      def truncate_load_table
        truncate_table(load_source, load_table) if load_type.eql?('truncate')
      end

      def clean_tmp_file
        ssh_rm(:local, self.load_file_path)
      end

    end
  end
end
