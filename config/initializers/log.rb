# -*- encoding : utf-8 -*-
class Themis::Log < Logger
  def format_message(severity, timestamp, progname, msg)
    "#{timestamp.strftime("%Y-%m-%d %H:%M:%S")} #{severity} #{msg}\n"
  end
end
LOG = Themis::Log.new('log/cron_log.log')
LOG.level = Logger::INFO
