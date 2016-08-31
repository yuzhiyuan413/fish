module Dock
  module Warehouse
    mattr_accessor :logger
    module Logging
      def logfile=(logfile)
        dock_logger = Logger.new(logfile)
        SSHKit.config.output = SSHKit::Formatter::Pretty.new(dock_logger) #setup the sshkit output.
        dock_logger.formatter = Dock::Warehouse::LoggingFormatter.new
        Dock::Warehouse.logger = dock_logger
      end

      def logger
        Dock::Warehouse.logger
      end
    end

    class LoggingFormatter < Logger::Formatter
      # Provide a call() method that returns the formatted message.
      def call(severity, time, program_name, message)
        "#{time.strftime("%Y-%m-%d %H:%M:%S")} #{severity} #{message}\n"
      end
    end

  end
end
