# -*- encoding : utf-8 -*-
class Charge::MonitorReport
  extend RedisCacheHelper
  include RatioHelper

  attr_accessor :model_name, :code_number, :dest_number, :province_id, :city_id,
    :operator_id, :sp_id, :report_hour
  DAILY_REPORT_MDL = Struct.new(:sp_name, :name, :deliver_num,
    :deliver_amount,:feedback_num, :feedback_amount, :feedback_num_ratio,
    :sp_feedback_num, :sp_feedback_amount, :sp_feedback_num_ratio,
    :sp_feedback_amount_ratio)

  HOURLY_REPORT_MDL = Struct.new(:hour_num, :request_num,:last_request_num,
    :request_ratio, :last_request_ratio, :deliver_num, :deliver_amount,
    :feedback_num, :feedback_amount, :sp_feedback_num, :sp_feedback_amount,
    :sp_feedback_num_ratio, :sp_feedback_amount_ratio)

  REPORT_FIELDS = [:deliver_num, :deliver_amount, :feedback_num, :feedback_amount,
    :sp_feedback_num, :sp_feedback_amount]
  REPORT_FIELDS_HASH = {
    10 => [{:deliver_num => :num }, {:deliver_amount => :total_amount}],
    20 => [{:feedback_num => :num}, {:feedback_amount => :total_amount}],
    30 => [{:sp_feedback_num => :num}, {:sp_feedback_amount => :total_amount}]}
  PROVINCE_CLAUSE = {select_columns: ["province_id name"], group_columns:  ["name"]}
  CITY_CLAUSE = {select_columns: ["city_id name"], group_columns:  ["name"]}
  CODE_CLAUSE = {select_columns: [:sp_name, "code_union_name name", :code_id],
      group_columns:  [:code_id]}
  DAILY_REPORTS_CACHE_KEY = "charge_monitor_daily"
  HOURLY_REPORTS_CACHE_KEY = "charge_monitor_hourly"
  DAILY_SUM_RECORD_CACHE_KEY = "charge_monitor_daily_sum_record"
  HOURLY_SUM_RECORD_CACHE_KEY = "charge_monitor_hourly_squm_record"
  HOURLY_COMPARISON_CACHE_KEY = "charge_monitor_hourly_comparison"
  YESTERDAY_HOURLY_CACHE_KEY = "charge_monitor_hourly_yesterday"
  HOURLY_REQUEST_REPORTS_CACHE_KEY = "charge_monitor_request_hourly"

  def initialize params = {}
    params.each{|k,v| self.send("#{k}=",v)} unless params.blank?
  end

  def daily_reports time_range = today
    tmp_records = section_monitor(time_range)
    tmp_records = tmp_records.group_by{|r| r.send("name")}
    tmp_records.collect do |k, v|
      r = DAILY_REPORT_MDL.new
      r.name = k.to_s.include?("_") ? k : @location_maps[k.to_s]
      v.each do |x|
        REPORT_FIELDS_HASH[x.code_event].each do |field|
          field.each do |f_k,f_v|
            r.send("#{f_k}=", x[f_v])
          end
        end
        if x.try(:sp_name) && x.try(:sp_name) != "none"
          r.sp_name = x.sp_name
        end
      end
      r.feedback_num_ratio = ratio(r.feedback_num, r.deliver_num)
      r.sp_feedback_num_ratio = ratio(r.sp_feedback_num, r.feedback_num)
      r.sp_feedback_amount_ratio = ratio(r.sp_feedback_amount, r.feedback_amount)
      r
    end
  end

  def hourly_reports time_range = today
    tmp_records = hourly_section_monitor(time_range)
    tmp_records = tmp_records.group_by{|r| r.hour_num}
    tmp_records.collect do |k, v|
      r = HOURLY_REPORT_MDL.new
      r.hour_num = k
      v.each do |x|
        REPORT_FIELDS_HASH[x.code_event].each do |field|
          field.each do |f_k,f_v|
            r.send("#{f_k}=", x[f_v])
          end
        end
      end
      r.sp_feedback_num_ratio = ratio(r.sp_feedback_num, r.feedback_num)
      r.sp_feedback_amount_ratio = ratio(r.sp_feedback_amount, r.feedback_amount)
      r
    end
  end


  def hourly_request_reports time_range = today
    daily_report_records = hourly_section_daily_monitor(time_range).group_by{|r| r.hour_num}
    last_daily_report_records = hourly_section_daily_monitor(yesterday).group_by{|r| r.hour_num}
    last_daily_report_records.collect do |k,v|
      item = {}.tap do |t|
        t[:hour_num] = k
        t[:last_request_num] = v[0].num
        t[:request_num] = daily_report_records[k][0].num if daily_report_records[k].present?
      end
    end
  end

  def merge_hourly_reports records, request_reports
    records.collect.with_index do |r, index|
      if r.hour_num == request_reports[index][:hour_num]
        r.last_request_num = request_reports[index][:last_request_num]
        r.request_num = request_reports[index][:request_num]
        r.request_ratio = ratio(r.deliver_num, r.request_num) if r.try(:request_num)
        r.last_request_ratio = ratio(r.deliver_num, r.last_request_num)
      end
    end
    records
  end

  def current_daily_reports
    (self.report_hour.blank? && form_attrs.blank? && Rails.cache.exist?(DAILY_REPORTS_CACHE_KEY)) ?
      Rails.cache.read(DAILY_REPORTS_CACHE_KEY) : daily_reports
  end

  def daily_sum_record records
    (self.report_hour.blank? && form_attrs.blank? && Rails.cache.exist?(DAILY_SUM_RECORD_CACHE_KEY)) ?
      Rails.cache.read(DAILY_SUM_RECORD_CACHE_KEY) : sum_record(records)
  end

  def current_hourly_reports
    (self.report_hour.blank? && form_attrs.blank? && Rails.cache.exist?(HOURLY_REPORTS_CACHE_KEY)) ?
      Rails.cache.read(HOURLY_REPORTS_CACHE_KEY) : hourly_reports
  end

  def current_hourly_for_request_reports
    (self.report_hour.blank? && form_attrs.blank? && Rails.cache.exist?(HOURLY_REQUEST_REPORTS_CACHE_KEY)) ?
      Rails.cache.read(HOURLY_REQUEST_REPORTS_CACHE_KEY) : hourly_request_reports
  end

  def hourly_sum_record records

    (self.report_hour.blank? && form_attrs.blank? && Rails.cache.exist?(HOURLY_SUM_RECORD_CACHE_KEY)) ?
      Rails.cache.read(HOURLY_SUM_RECORD_CACHE_KEY) : sum_record(records, :hourly)
  end

  def comparison today_records
    if form_attrs.blank? && Rails.cache.exist?(HOURLY_COMPARISON_CACHE_KEY)
      Rails.cache.read(HOURLY_COMPARISON_CACHE_KEY)
    elsif form_attrs.blank?
      Charge::MonitorReport.hourly_reports_comparison(today_records)
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
    unless mode == :daily
      r.request_num = records.map(&:request_num).compact.sum
      r.last_request_num = records.map(&:last_request_num).compact.sum
      r.request_ratio = r.deliver_num.to_i/r.request_num.to_f if r.try(:request_num)
      r.last_request_ratio = r.deliver_num.to_i/r.last_request_num.to_f
    end
    r
  end

  def self.refresh_cache
		charge_monitor_report = Charge::MonitorReport.new
		daily_reports = charge_monitor_report.daily_reports
		hourly_reports = charge_monitor_report.hourly_reports
    hourly_request_reports = charge_monitor_report.hourly_request_reports
    hourly_reports = charge_monitor_report.merge_hourly_reports(hourly_reports, hourly_request_reports)
    daily_sum_record = charge_monitor_report.sum_record(daily_reports)
    hourly_sum_record = charge_monitor_report.sum_record(hourly_reports,:hourly)
    comparison_result = hourly_reports_comparison(hourly_reports)

		reset_cache(DAILY_REPORTS_CACHE_KEY, daily_reports)
		reset_cache(HOURLY_REPORTS_CACHE_KEY, hourly_reports)
    reset_cache(HOURLY_REQUEST_REPORTS_CACHE_KEY, hourly_request_reports)
		reset_cache(HOURLY_COMPARISON_CACHE_KEY, comparison_result)
    reset_cache(DAILY_SUM_RECORD_CACHE_KEY, daily_sum_record)
    reset_cache(HOURLY_SUM_RECORD_CACHE_KEY, hourly_sum_record)
  end

  def self.refresh_yesterday_hourly_reports_cache
    yesterday = (Date.yesterday.beginning_of_day..Date.yesterday.end_of_day)
		yesterday_hourly_reports = Charge::MonitorReport.new.hourly_reports(yesterday)
    reset_cache(YESTERDAY_HOURLY_CACHE_KEY, yesterday_hourly_reports)
  end



  private
  def self.compare num_a, num_b
    (num_a.to_i - num_b.to_i) / num_a.to_f
  end

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

  def location_clause
    @location_maps = PandaDs::City.city_options
    province_id = form_attrs[:province_id].blank? ?
      '-1' : form_attrs[:province_id]
    city_id = form_attrs[:city_id].blank? ?
      '-1' : form_attrs[:city_id]
    location_ticket = [province_id, city_id].join(',')
    case location_ticket
    when /^0,(0|-1)/
      @location_maps = PandaDs::City.province_options
      PROVINCE_CLAUSE
    when '-1,0'; CITY_CLAUSE
    when '-1,-1'; CODE_CLAUSE
    when /^[1-9]{1}[0-9]{0,1},0/
      {}.tap do |x|
        x.merge! CITY_CLAUSE
        x[:conditions] = {province_id: province_id}
      end
    when /^[1-9]{1}[0-9]{0,1},[1-9]{1}[0-9]{0,3}/
      {}.tap do |x|
        x.merge! CODE_CLAUSE
        x[:conditions] = {province_id: province_id, city_id: city_id}
      end
    when /^[1-9]{1}[0-9]{0,1},-1/
      {}.tap do |x|
        x.merge! CODE_CLAUSE
        x[:conditions] = {province_id: province_id}
      end
    end
  end

  def hourly_section_monitor time_range
    select_columns = [:code_event, "hour(server_time) hour_num",
      "COUNT(DISTINCT uuid) num", "SUM(amount) total_amount"]
    group_columns = ["hour_num", :code_event]
    conditions = { server_time: time_range}
    conditions.merge!(conditions_without_location)
    conditions.merge!(location_clause[:conditions]) if location_clause[:conditions]
    CrabDs::CodeHistory.select(select_columns).where(conditions).where(
      "amount > -1").group(group_columns)
  end

  def hourly_section_daily_monitor time_range
    select_columns = ["COUNT(DISTINCT current_uuid) num", "hour(record_time) hour_num"]
    conditions = { record_time: time_range}
    conditions.merge!({operator_id: @operator_id}) if @operator_id.present?
    conditions.merge!(location_clause[:conditions]) if location_clause[:conditions]
    DailyDs::SmartRequestHistory.select(select_columns).where(conditions).group("hour_num")
  end

  def section_monitor time_range
    select_columns = [:code_event, "COUNT(DISTINCT uuid) num",
      "SUM(amount) total_amount"]
    group_columns = [:code_event]
    conditions = date_condition(time_range)
    select_columns += location_clause[:select_columns]
    group_columns += location_clause[:group_columns]
    conditions.merge!(conditions_without_location)
    conditions.merge!(location_clause[:conditions]) if location_clause[:conditions]
    CrabDs::CodeHistory.select(select_columns).where(conditions).where(
      "amount > -1").group(group_columns)
  end

  def form_attrs
    {}.tap do |x|
      [:code_number, :dest_number, :province_id, :city_id,
       :operator_id, :sp_id].each do |attr|
        x[attr] = self.send(attr) unless self.send(attr).blank?
      end
    end
  end

  def conditions_without_location
    {}.tap do |x|
      [:code_number, :dest_number, :operator_id, :sp_id].each do |attr|
        x[attr] = self.send(attr) unless self.send(attr).blank?
      end
    end
  end

  def date_condition(time_range)
    self.report_hour.blank? ? {server_time: time_range} : {server_time: report_hour_range}
  end

  def report_hour_range
    (Time.parse(Time.now.strftime("%F #{self.report_hour}:00:00"))..Time.parse(
      Time.now.strftime("%F #{self.report_hour}:59:59")))
  end

  def today
    (Date.today.beginning_of_day..Date.today.end_of_day)
  end

  def yesterday
    (Date.today.ago(1).beginning_of_day..Date.today.ago(1).end_of_day)
  end
end
