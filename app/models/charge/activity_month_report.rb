# -*- encoding : utf-8 -*-
class Charge::ActivityMonthReport < ActiveRecord::Base
  #attr_accessible :activity_num, :cmcc_num, :ctcc_num, :cucc_num, :others_sp_num, :province, :report_date, :request_per_avg, :request_times, :tag

  def search
    conditions = {:tag => tag, :report_date => report_date, :product_version => product_version}
    conditions[:province] = province unless province == "全部省份"
    hide_where_clause = "activity_num != 0"
    Charge::ActivityMonthReport.where(conditions).where(hide_where_clause).order(:activity_num => :desc)
  end

  def self.tags
    select("distinct tag").order(:tag => :desc).map(&:tag).compact
  end

  def self.product_versions
    select("distinct product_version").order(:product_version => :desc).map(&:product_version).compact
  end
end
