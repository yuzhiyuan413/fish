namespace :report do
  desc "种子新增用户报表小时任务"
  task :hourly_seed_activation_report => :environment do
    ReportEngines::ReportEngine.new.perform(:hourly_seed_activation)
  end

  desc "种子新增用户报表每日任务"
  task :seed_activation_report => :environment do
    ReportEngines::ReportEngine.new.perform(:seed_activation)
  end

  desc "种子活跃报表小时任务"
  task :hourly_seed_activity_report => :environment do
    ReportEngines::ReportEngine.new.perform(:hourly_seed_activity)
  end

  desc "种子活跃报表每日任务"
  task :seed_activity_report => :environment do
    ReportEngines::ReportEngine.new.perform(:seed_activity)
  end

  desc "种子方案执行每日任务"
  task :seed_solution_report => :environment do
    ReportEngines::ReportEngine.new.perform(:seed_solution_group, :group)
  end

  desc "种子方案执行每小时任务"
  task :hourly_seed_solution_report => :environment do
    ReportEngines::ReportEngine.new.perform(:hourly_seed_solution_group, :group)
  end

  desc "种子终端厂商每日任务"
  task :seed_prop_report => :environment do
    ReportEngines::ReportEngine.new.perform(:seed_prop)
  end

  desc "种子终端厂商每小时任务"
  task :hourly_seed_prop_report => :environment do
    ReportEngines::ReportEngine.new.perform(:hourly_seed_prop)
  end

  desc "种子终端属性每日任务"
  task :seed_prop_detail_report => :environment do
    ReportEngines::ReportEngine.new.perform(:seed_prop_detail)
  end

  desc "种子终端属性每小时任务"
  task :hourly_seed_prop_detail_report => :environment do
    ReportEngines::ReportEngine.new.perform(:hourly_seed_prop_detail)
  end

  desc "种子系统参数每日任务"
  task :seed_device_detail_report => :environment do
    ReportEngines::ReportEngine.new.perform(:seed_device_detail)
  end

  desc "种子系统参数每小时任务"
  task :hourly_seed_device_detail_report => :environment do
    ReportEngines::ReportEngine.new.perform(:hourly_seed_device_detail)
  end

  desc "种子终端属性月报每日任务"
  task :seed_prop_detail_month_report => :environment do
    ReportEngines::ReportEngine.new.perform(:seed_prop_detail_month)
  end


  desc "种子留存报表每日任务"
  task :seed_alive_report => :environment do
    ReportEngines::ReportEngine.new.perform(:seed_alive, :group)
  end

  desc "种子用户概况报表每小时任务"
  task :hourly_seed_activity_situation_report => :environment do
    ReportEngines::ReportEngine.new.perform(:hourly_seed_activity_situation_group, :group)
  end

  desc "种子用户概况总计每日任务"
  task :seed_activity_total_report => :environment do
    ReportEngines::ReportEngine.new.perform(:seed_activity_total)
  end

  desc "种子全事件到达报表每日任务"
  task :seed_arrival_report => :environment do
    ReportEngines::ReportEngine.new.perform(:seed_arrival)
  end

  desc "种子全事件到达报表每小时任务"
  task :hourly_seed_arrival_report => :environment do
    ReportEngines::ReportEngine.new.perform(:hourly_seed_arrival)
  end

  desc "包篡改数据生成"
  task :apk_md5_alarm_record => :environment do
    Command::CommandCenter.new.run(:generate_apk_md5_alarms_record)
  end

  desc "计费用户新增报表日任务"
  task :charge_activation_report => :environment do
    ReportEngines::ReportEngine.new.perform(:charge_activation)
  end

  desc "计费用户新增报表小时任务"
  task :hourly_charge_activation_report => :environment do
    ReportEngines::ReportEngine.new.perform(:hourly_charge_activation)
  end

  desc "计费用户活跃报表日任务"
  task :charge_activity_report => :environment do
    ReportEngines::ReportEngine.new.perform(:charge_activity)
  end

  desc "计费用户活跃报表小时任务"
  task :hourly_charge_activity_report => :environment do
    ReportEngines::ReportEngine.new.perform(:hourly_charge_activity)
  end

  desc "计费用户活跃月报表日任务"
  task :charge_activity_month_report => :environment do
    ReportEngines::ReportEngine.new.perform(:charge_activity_month)
  end

  desc "计费用户活跃留存报表日任务"
  task :charge_alive_report => :environment do
    ReportEngines::ReportEngine.new.perform(:charge_alive, :group)
  end

  desc "计费用户概况报表小时任务"
  task :hourly_charge_situation_report => :environment do
    ReportEngines::ReportEngine.new.perform(:hourly_charge_situation, :group)
  end

  desc "计费用户概况累计报表日任务"
  task :charge_total_report => :environment do
    ReportEngines::ReportEngine.new.perform(:charge_total)
  end

  desc "易打工事件转化率日任务"
  task :ework_conversion_report => :environment do
    ReportEngines::ReportEngine.new.perform(:ework_conversion)
  end

  desc "易打工事件转化率小时任务"
  task :hourly_ework_conversion_report => :environment do
    ReportEngines::ReportEngine.new.perform(:hourly_ework_conversion)
  end

  desc "易打工全业务线到达日任务"
  task :ework_arrival_report => :environment do
    ReportEngines::ReportEngine.new.perform(:ework_arrival)
  end

  desc "易打工全业务线到达小时任务"
  task :hourly_ework_arrival_report => :environment do
    ReportEngines::ReportEngine.new.perform(:hourly_ework_arrival)
  end

  desc "生成留存率中位数"
  task :stay_alive_medians => :environment do
    Command::CommandCenter.new.run(:generate_seed_alive_medians)
  end

  desc "生成易打工事件转化率报表中位数"
  task :ework_conversion_median => :environment do
    Command::CommandCenter.new.run(:generate_ework_conversion_medians)
  end

  desc "种子终端属性月汇总报表"
  task :seed_prop_detail_monthly_report => :environment do
    Command::CommandCenter.new.run(:generate_seed_prop_detail_monthly)
  end

  desc "刷新支付监控报表缓存"
  task :refresh_charge_monitor_report_cache => :environment do
    Charge::MonitorReport.refresh_cache
  end

  desc "刷新支付监控报表缓存2"
  task :refresh_charge_monitor_report_cache2 => :environment do
    Charge::Monitor2Report.refresh_cache
  end

  desc "身份、城市、运营商、渠道定时刷新"
  task :refresh_provice_city_operator_sp_cache => :environment do
    PandaDs::Province.refresh_cache
    PandaDs::City.refresh_cache
    PandaDs::Operator.refresh_cache
    SmartDs::ServiceProvider.refresh_cache
    SmartDs::CodeBusinessType.refresh_cache
  end

  desc "刷新支付监控昨日报表缓存"
  task :refresh_yesterday_hourly_reports_cache => :environment do
    Charge::MonitorReport.refresh_yesterday_hourly_reports_cache
  end

  desc "刷新支付监控昨日报表缓存2"
  task :refresh_yesterday_hourly_reports_cache2 => :environment do
    Charge::Monitor2Report.refresh_yesterday_hourly_reports_cache
  end

  desc "生成当月包月留存报表数据"
  task :monthly_code_alive_report => :environment do
    now = Time.now
    Charge::MonthlyCodeAliveReportGenerator.new(now.year, now.month).build
  end

  desc "生成上月包月留存报表数据"
  task :monthly_code_alive_report_of_last_month => :environment do
    date = Time.now - 1.month
    Charge::MonthlyCodeAliveReportGenerator.new(date.year, date.month).build
  end

  desc "生成中天包月下行报表数据"
  task :zhongtian_monthly_code_downlink_report => :environment do
    from_date = ENV['from'] ? Date.parse(ENV['from']) : Date.yesterday
    end_date  = ENV['to'] ? Date.parse(ENV['to']) : Date.yesterday

    (from_date..end_date).each do |date|
      Charge::MonthlyCodeDownlinkReportGenerator.generate_reports(date)
    end
  end

end
