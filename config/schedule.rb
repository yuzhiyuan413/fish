# -*- encoding : utf-8 -*-
# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

set :output, File.join(Whenever.path, "log", "cron_log.log")
set :environment, :production

job_type :rake,   "cd :path && RAILS_ENV=:environment bundle exec rake --silent :task :output"
job_type :runner, "cd :path && script/runner -e :environment :task :output"

# every 10.minutes do
#   rake "report:refresh_charge_monitor_report_cache"
# end
#
# every 10.minutes do
# 	rake "report:refresh_provice_city_operator_sp_cache"
# end
# 
# every 1.day, :at => "01:00" do
# 	rake "report:refresh_yesterday_hourly_reports_cache"
# end
#
# every '0 0,1,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23 * * *' do
#   rake "report:hourly_charge_activation_report"
# end
#
# every 1.day, :at => "02:00" do
#   rake "report:charge_activation_report date=last1days"
# end
