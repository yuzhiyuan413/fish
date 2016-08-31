module Dock
  module Warehouse
    class Stevedore
      include Logging
      JOB_CONF_PATH = "#{Rails.root}/config/jobs.yml"

      def initialize
        super
        setup_logger
      end

      def jobs
        @jobs ||= parse_job_yml
      end

      def perform tag
        begin
          job_list = tag.nil? ? jobs : jobs.select{|x| x.tag == tag}
          job_list.map &:perform
        rescue => e
          logger.error e
          logger.error e.backtrace
        end
      end

      private
        def parse_job_yml
          jobs_conf = YAML.load_file(JOB_CONF_PATH)
          jobs_conf.values.collect{|x| "Dock::Warehouse::#{x['job_type']}".constantize.new(x) }
        end

        def setup_logger
          # self.logfile = 'log/dock.log'
          self.logfile = STDOUT
        end

    end
  end
end
