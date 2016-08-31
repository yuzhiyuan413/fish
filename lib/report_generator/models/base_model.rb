module ReportGenerator
  module Models
    class BaseModel
      include ReportGenerator::Logging

      def initialize
        setup_logger
      end

      private
      def setup_logger
        # self.logfile = 'log/xxx.log'
        self.logfile = STDOUT
      end

    end
  end
end
