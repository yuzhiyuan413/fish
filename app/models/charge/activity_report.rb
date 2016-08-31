# -*- encoding : utf-8 -*-
class Charge::ActivityReport < ActiveRecord::Base
  #attr_accessible :activity_num, :cmcc_num, :ctcc_num, :cucc_num, :others_sp_num, :product_version, :province, :report_date, :request_per_avg, :request_times, :tag
  attr_accessor :from_date, :end_date, :operator

  def search
    conditions = {:product_version => product_version,
                  :tag => tag,
                  :province => province,
                  :report_date => from_date..end_date}
    hide_where_clause = "activity_num != 0"
    Charge::ActivityReport.where(conditions).where(hide_where_clause).order(:report_date)
  end

  def trend_report_search
    operator_column = ModelMappings::OPERATOR_NAME_TO_COLUMN[operator]
    select_clause = "province, #{operator_column} activity_nums, report_date"
    conditions = {:product_version => product_version,
                  :tag => tag,
                  :report_date => Date.parse(from_date).beginning_of_day..Date.parse(end_date).end_of_day}
    group_columns = [:province]
    order_colums = group_columns << :report_date
    records = Charge::ActivityReport.select(select_clause).where(conditions).group(group_columns).order(order_colums)
    records = records.group_by{|r| r.province}
    records.collect do |k, v|
      {}.tap do |t|
        t[k] = {}
        v.each do |item|
          t[k][item.report_date.to_s] = item.activity_nums
        end
      end
    end

  end

  def day_header
    (Date.parse(from_date)..Date.parse(end_date)).to_a.sort{ |x,y| y <=> x }
  end

  # def trend_columns
  #   columns = {}
  #   column_range = (Date.parse(from_date)..Date.parse(end_date))
  #   column_range.to_a.map(&:to_s).each do |k|
  #     columns[k] = nil
  #   end
  #   columns
  # end

  def trend
    return {} if activity_nums.blank?
    data = {}
    activity_nums.split(',').each do |i|
      data[i[0,10]] = i[10,i.length]
    end
    data
  end

  def activity_nums
    read_attribute(:activity_nums)
  end


  def self.tags
    select("distinct tag").order(:tag => :desc).map(&:tag).compact
  end

  def self.product_versions
    select("distinct product_version").where("report_date > '2015-02-01'").order(:product_version => :desc).map(&:product_version).compact
  end

  private
    def trend_report_headers
      headers = {}
      (Date.parse(from_date)..Date.parse(end_date)).to_a.each{|i| headers[i]=nil}
      headers
    end
end
