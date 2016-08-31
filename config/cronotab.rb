# cronotab.rb — Crono configuration file
#
# Here you can specify periodic jobs and schedule.
# You can use ActiveJob's jobs from `app/jobs/`
# You can use any class. The only requirement is that
# class should have a method `perform` without arguments.
require 'rake'
require_all 'lib/dock'

Themis::Application.load_tasks

# Get all tags from job list and define a job class for each tag.
tags = Dock::Warehouse::Stevedore.new.jobs.map(&:tag).compact.uniq
tags.each do |tag|
  kclass_name = tag.camelize
  kclass = <<-CODE
  class #{kclass_name} < ActiveJob::Base
    def perform
      Rake::Task['etl:#{tag}'].invoke
    end
  end
  CODE
  eval kclass
end

# Dock Job Schedule Configuration
Crono.perform(Crab).every 1.hour, at: {min: 0}
Crono.perform(Ework).every 1.hour, at: {min: 0}
Crono.perform(Sword).every 1.hour, at: {min: 0}
Crono.perform(SwordHdfsHourly).every 1.hour, at: {min: 20}
Crono.perform(SmartHdfsHourly).every 1.hour, at: {min: 20}
Crono.perform(EworkHdfsHourly).every 1.hour, at: {min: 20}
Crono.perform(SwordClean).every 1.day, at: {hour: 05, min: 0}
Crono.perform(CrabClean).every 1.day,  at: {hour: 05, min: 10}
Crono.perform(SwordHdfsClean).every 1.day,  at: {hour: 05, min: 20}
Crono.perform(SmartHdfsClean).every 1.day,  at: {hour: 05, min: 30}
Crono.perform(EworkHdfsClean).every 1.day,  at: {hour: 05, min: 40}
