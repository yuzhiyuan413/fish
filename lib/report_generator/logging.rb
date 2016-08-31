module ReportGenerator
    mattr_accessor :logger
    module Logging
      def logfile=(logfile)
        generator_logger = Logger.new(logfile)
        generator_logger.formatter = ReportGenerator::LoggingFormatter.new
        ReportGenerator.logger = generator_logger
      end

      def logger
        ReportGenerator.logger
      end
    end

    class LoggingFormatter < Logger::Formatter
      # Provide a call() method that returns the formatted message.
      def call(severity, time, program_name, message)
        "#{time.strftime("%Y-%m-%d %H:%M:%S")} #{severity} #{message}\n"
      end
    end
end
