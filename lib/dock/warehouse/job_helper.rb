module Dock
  module Warehouse
    module JobHelper
      CALPONT_TBL_DIR = "/usr/local/Calpont/data/bulk/data/import"

      def print_job_info job_inst
        logger.info "====================JOB INFO========================"
        job_inst.instance_variable_names.sort.each do |name|
          method_name = name[1..name.length]
          logger.info "#{method_name}: #{job_inst.method(method_name).call.to_s}"
        end
        logger.info "===================================================="
      end

      def truncate_table source, tbl
        exec_sql(source, "truncate table #{tbl}")
      end

      def get_table_engine source, tbl
        sql = <<-SQL
          select engine from information_schema.tables
          where table_name='#{tbl}'
          and table_schema='#{source.database}';
        SQL
        exec_sql(source, sql).first.first
      end

      ## Extract table data into csv file.
      def extract_csv job_inst
        sql = <<-SQL
          select #{job_inst.extract_fields} from #{job_inst.extract_table}
          where #{job_inst.increment_field} > #{job_inst.increment_ident} #{job_inst.extract_clause}
          into outfile '#{job_inst.extract_file_path}' fields terminated by '#{job_inst.delimiter}'
        SQL
        exec_sql(job_inst.extract_source, sql)
      end

      def load_csv job_inst
      	if job_inst.load_table_engine.eql?('InfiniDB')
      	  load_csv_into_infinidb(job_inst)
      	else
      	  load_csv_into_innodb(job_inst)
      	end
      end

      def load_csv_into_infinidb job_inst
        on(:local) do |host|
          strip_lf_cmd = 'sed -e :a -e \'/\\\\$/N; s/\\\\\n//; ta\''
          tbl_file_path = "#{CALPONT_TBL_DIR}/#{job_inst.tag}_#{job_inst.load_table}.tbl"
          tmp_file_path = "#{job_inst.load_dir}/#{job_inst.tag}_#{job_inst.load_table}.csv.bak"

          execute("touch #{tbl_file_path}")
          execute("rm #{tbl_file_path}")
          execute("#{strip_lf_cmd} #{job_inst.load_file_path} > #{tmp_file_path}")
          execute("ln -s #{tmp_file_path} #{tbl_file_path}")
          execute("/usr/local/Calpont/bin/cpimport -j#{job_inst.job_id}")
        end
      end

      def load_csv_into_innodb job_inst
        raise "CSV File does't exist!" if not File.exist?(job_inst.load_file_path)
        with_autocommit_off(job_inst.load_source) do
          with_unique_checks_off(job_inst.load_source) do
            sql = <<-SQL
              load data infile '#{job_inst.load_file_path}'
              ignore into table #{job_inst.load_table}
              fields terminated by '#{job_inst.delimiter}'
              #{job_inst.load_fields if job_inst.respond_to?(:load_fields)}
            SQL
            exec_sql(job_inst.load_source, sql)
          end
        end
      end

      ## Run shell command and record execution status, elapsed time.
      ## if the command executed failed raise a runtime exception.
      def exec_shell cmd
        result = false
        on(:local) do |host|
          execute(cmd)
        end
      end

      def exec_sql source, sql
        result = nil
        sec = Benchmark.realtime do
          result = source.connection.execute sql
        end
        logger.info "Job ID: #{job_id}, Executed SQL: {#{sql.strip.delete("\n")}}, Elapsed Time: #{sec.to_i} s"
        result
      end

      def with_keys_off source, tbl
        exec_sql(source, "ALTER TABLE #{tbl} DISABLE KEYS")
        yield
        exec_sql(source, "ALTER TABLE #{tbl} ENABLE KEYS")
      end

      def with_autocommit_off source
        exec_sql(source, "SET autocommit=0")
        yield
        exec_sql(source, "COMMIT")
      end

      def with_unique_checks_off source
        exec_sql(source, "SET unique_checks=0")
        yield
        exec_sql(source, "SET unique_checks=1")
      end

      def with_foreign_key_checks_off source
        exec_sql(source, "SET foreign_key_checks=0")
        yield
        exec_sql(source, "SET foreign_key_checks=1")
      end

      def ssh_rm host_string, file_path
        on(host_string) do |host|
          execute("rm -rf #{file_path}")
        end
      end

      def ssh_download! host_string, download_from, download_to
        on(host_string) do |host|
          download!(download_from, download_to)
        end
      end

      def parse_ruby_exp str
        rexp = /\#{(?<exp>(.*))}/
        match_result = str.match rexp
        if match_result
          parse_result = eval match_result[:exp]
          str.gsub(rexp, parse_result)
        else
          str
        end
      end

    end
  end
end
