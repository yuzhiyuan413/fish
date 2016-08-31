# -*- encoding : utf-8 -*-
class Charge::Monitor2Report
  extend RedisCacheHelper
  include RatioHelper
  attr_accessor :model_name, :code_number, :dest_number, :province_id, :city_id,
    :operator_id, :sp_id, :report_hour, :host_fullname
  DAILY_REPORT_MDL = Struct.new(:name, :sp_name, :deliver_num, :deliver_amount,
    :feedback_num, :feedback_amount, :feedback_num_ratio, :sp_feedback_num,
    :sp_feedback_amount, :sp_feedback_num_ratio, :sp_feedback_amount_ratio)

  HOURLY_REPORT_MDL = Struct.new(:hour_num, :deliver_num, :deliver_amount,
    :feedback_num, :feedback_amount, :sp_feedback_num, :sp_feedback_amount,
    :sp_feedback_num_ratio, :sp_feedback_amount_ratio)

  REPORT_FIELDS = [:deliver_num, :deliver_amount, :feedback_num, :feedback_amount,
    :sp_feedback_num, :sp_feedback_amount]

  DAILY_REPORTS_CACHE_KEY = "charge_monitor_daily2"
  HOURLY_REPORTS_CACHE_KEY = "charge_monitor_hourly2"
  DAILY_SUM_RECORD_CACHE_KEY = "charge_monitor_daily_sum_record2"
  HOURLY_SUM_RECORD_CACHE_KEY = "charge_monitor_hourly_squm_record2"
  HOURLY_COMPARISON_CACHE_KEY = "charge_monitor_hourly_comparison2"
  YESTERDAY_HOURLY_CACHE_KEY = "charge_monitor_hourly_yesterday2"

  def initialize params = {}
    params.each{|k,v| self.send("#{k}=",v)} unless params.blank?
  end

  def daily_reports time_range = today
    tmp_records = section_deliver(:daily, time_range) +
      section_feedback(:daily, time_range) +
      section_sp_feedback(:daily, time_range)
    tmp_records = tmp_records.group_by{|r| [r.name, r.sp_name]}
    tmp_records.collect do |k, v|
      r = DAILY_REPORT_MDL.new
      r.name, r.sp_name = k[0], k[1]
      v.each do |x|
        REPORT_FIELDS.each do |field|
          val =  x.try(field)
          r.send("#{field}=", val) if val.present?
        end
      end
      r.feedback_num_ratio = ratio(r.feedback_num, r.deliver_num)
      r.sp_feedback_num_ratio = ratio(r.sp_feedback_num, r.feedback_num)
      r.sp_feedback_amount_ratio = ratio(r.sp_feedback_amount, r.feedback_amount)
      r
    end
  end

  def hourly_reports time_range = today
    tmp_records = section_deliver(:hourly, time_range) +
      section_feedback(:hourly, time_range) +
      section_sp_feedback(:hourly, time_range)
    tmp_records = tmp_records.group_by{|r| r.hour_num}
    tmp_records.collect do |k, v|
      r = HOURLY_REPORT_MDL.new
      r.hour_num = k
      v.each do |x|
        REPORT_FIELDS.each do |field|
          val =  x.try(field)
          r.send("#{field}=", val) if val.present?
        end
      end
      r.sp_feedback_num_ratio = ratio(r.sp_feedback_num, r.feedback_num)
      r.sp_feedback_amount_ratio = ratio(r.sp_feedback_amount, r.feedback_amount)
      r
    end
  end

  def current_daily_reports
    (self.report_hour.blank? && form_conditions.blank? && Rails.cache.exist?(DAILY_REPORTS_CACHE_KEY)) ?
      Rails.cache.read(DAILY_REPORTS_CACHE_KEY) : daily_reports
  end

  def daily_sum_record records
    (self.report_hour.blank? && form_conditions.blank? && Rails.cache.exist?(DAILY_SUM_RECORD_CACHE_KEY)) ?
      Rails.cache.read(DAILY_SUM_RECORD_CACHE_KEY) : sum_record(records)
  end

  def current_hourly_reports
    (self.report_hour.blank? && form_conditions.blank? && Rails.cache.exist?(HOURLY_REPORTS_CACHE_KEY)) ?
      Rails.cache.read(HOURLY_REPORTS_CACHE_KEY) : hourly_reports
  end

  def hourly_sum_record records
    (self.report_hour.blank? && form_conditions.blank? && Rails.cache.exist?(HOURLY_SUM_RECORD_CACHE_KEY)) ?
      Rails.cache.read(HOURLY_SUM_RECORD_CACHE_KEY) : sum_record(records, :hourly)
  end

  def comparison today_records
    if form_conditions.blank? && Rails.cache.exist?(HOURLY_COMPARISON_CACHE_KEY)
      Rails.cache.read(HOURLY_COMPARISON_CACHE_KEY)
    elsif form_conditions.blank?
      Charge::Monitor2Report.hourly_reports_comparison(today_records)
    else
      {}
    end
  end

  def sum_record records,mode = :daily
    return nil if records.blank?
    r = OpenStruct.new
    r.deliver_num = records.map(&:deliver_num).compact.sum
    r.deliver_amount = records.map(&:deliver_amount).compact.sum
    r.feedback_num = records.map(&:feedback_num).compact.sum
    r.feedback_amount = records.map(&:feedback_amount).compact.sum
    r.sp_feedback_num = records.map(&:sp_feedback_num).compact.sum
    r.sp_feedback_amount = records.map(&:sp_feedback_amount).compact.sum
    r.feedback_num_ratio = r.feedback_num.to_i/r.deliver_num.to_f unless mode.equal?(:hourly)
    r.sp_feedback_num_ratio = r.sp_feedback_num.to_i/r.feedback_num.to_f
    r.sp_feedback_amount_ratio = r.sp_feedback_amount.to_i/r.feedback_amount.to_f
    r
  end

  def self.refresh_cache
		charge_monitor_report = Charge::Monitor2Report.new
		daily_reports = charge_monitor_report.daily_reports
		hourly_reports = charge_monitor_report.hourly_reports

    daily_sum_record = charge_monitor_report.sum_record(daily_reports)
    hourly_sum_record = charge_monitor_report.sum_record(hourly_reports,:hourly)
    comparison_result = hourly_reports_comparison(hourly_reports)

		reset_cache(DAILY_REPORTS_CACHE_KEY, daily_reports)
		reset_cache(HOURLY_REPORTS_CACHE_KEY, hourly_reports)
		reset_cache(HOURLY_COMPARISON_CACHE_KEY, comparison_result)
    reset_cache(DAILY_SUM_RECORD_CACHE_KEY, daily_sum_record)
    reset_cache(HOURLY_SUM_RECORD_CACHE_KEY, hourly_sum_record)
  end

  def self.refresh_yesterday_hourly_reports_cache
    yesterday = (Date.yesterday.beginning_of_day..Date.yesterday.end_of_day)
    yesterday_hourly_reports = Charge::Monitor2Report.new.hourly_reports(yesterday)
    reset_cache(YESTERDAY_HOURLY_CACHE_KEY, yesterday_hourly_reports)
  end

  def report_hour_range
    (Time.parse(Time.now.strftime("%F #{self.report_hour}:00:00"))..Time.parse(
      Time.now.strftime("%F #{self.report_hour}:59:59")))
  end

  private
  def self.current_yesterday_hourly_reports
    Rails.cache.exist?(YESTERDAY_HOURLY_CACHE_KEY) ?
      Rails.cache.read(YESTERDAY_HOURLY_CACHE_KEY) : []
  end

  def self.hourly_reports_comparison today_records
    {}.tap do |x|
      yesterday_records = current_yesterday_hourly_reports.select do |x|
        x.hour_num < Time.now.hour
      end
      comparison_reports = yesterday_records + today_records
      comparison_reports.group_by{|r| r.hour_num}.each do |hour_num, records|
        x[hour_num] = {}
        if records.size == 2
          REPORT_FIELDS.each do |field|
            ratio = compare(records[0].send(field), records[1].send(field))
            x[hour_num][field] = ratio if ratio > 0.2
          end
        end
      end
    end
  end

  def self.compare num_a, num_b
    (num_a.to_i - num_b.to_i) / num_a.to_f
  end

  def section_deliver table_mode, time_range
    select_columns = ["COUNT(DISTINCT uuid) deliver_num, SUM(deliver_amount) deliver_amount"]
    group_columns = []
    case table_mode when :daily
      select_columns.unshift(:sp_name)
      select_columns.unshift("CONCAT(code_number, '_', dest_number) name")
      group_columns << "name"
      time_condition = self.report_hour.blank? ? {server_time: time_range} :
        {server_time: report_hour_range}
    when :hourly
      select_columns.unshift("hour(server_time) hour_num")
      group_columns << "hour_num"
      time_condition = {server_time: time_range}
    end
    CrabDs::CodeDeliverHistory.select(select_columns).where(
      time_condition).where(form_conditions).where("deliver_amount > -1").group(group_columns)
  end

  def section_feedback table_mode, time_range
    select_columns = ["COUNT(DISTINCT uuid) feedback_num, SUM(t_amount) feedback_amount"]
    group_columns = []
    case table_mode when :daily
      select_columns.unshift(:sp_name)
      select_columns.unshift("CONCAT(code_number, '_', dest_number) name")
      group_columns << "name"
      time_condition = self.report_hour.blank? ? {t_record_time: time_range} :
        {t_record_time: report_hour_range}
    when :hourly
      select_columns.unshift("hour(t_record_time) hour_num")
      group_columns << "hour_num"
       time_condition = {t_record_time: time_range}
    end
    CrabDs::CodeDeliverHistory.select(select_columns).where(
      time_condition).where(form_conditions).where("t_amount > -1").group(group_columns)
  end

  def section_sp_feedback table_mode, time_range
    select_columns = ["COUNT(DISTINCT uuid) sp_feedback_num, SUM(a_amount) sp_feedback_amount"]
    group_columns = []
    case table_mode when :daily
      select_columns.unshift(:sp_name)
      select_columns.unshift("CONCAT(code_number, '_', dest_number) name")
      group_columns << "name"
      time_condition = self.report_hour.blank? ? {a_record_time: time_range} :
        {a_record_time: report_hour_range}
    when :hourly
      select_columns.unshift("hour(a_record_time) hour_num")
      group_columns << "hour_num"
      time_condition = {a_record_time: time_range}
    end
    CrabDs::CodeDeliverHistory.select(select_columns).where(
      time_condition).where(form_conditions).where("a_amount > -1").group(group_columns)
  end

  def form_conditions
    {}.tap do |x|
      [:code_number, :dest_number, :province_id, :city_id,
       :operator_id, :sp_id, :host_fullname].each do |attr|
        x[attr] = self.send(attr) unless self.send(attr).blank?
      end
    end
  end

  def today
    (Date.today.beginning_of_day..Date.today.end_of_day)
  end
end
