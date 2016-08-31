# -*- encoding : utf-8 -*-
class Charge::SituationReport < ActiveRecord::Base
  attr_accessible :activation_num, :activity_num, :avg_request_times, :product_version, :record_time, :request_times, :tag
  include RatioHelper
  def situation_reports
    items = %w{今日 昨日此时 昨日全天}
    situation_reports = []
    items.each do |item|
      where_causes = {:tag => tag, :product_version => product_version, :record_time => item }
      situation_reports << Charge::SituationReport.where(where_causes).first
    end
    situation_reports
  end

  def total_report
    where_causes = {:tag => tag, :product_version => product_version}
    records = Charge::TotalReport.where(where_causes).tap{|x| p x}
    records.map do |r|
      { 
        total_activation_num: r.total_activation_num, yesterday_activation_num: r.yesterday_activation_num,
        yesterday_activity_num: r.yesterday_activity_num, activity7: r.activity7,
        activity30: r.activity30,
        ratio_yesterday_activation: ratio(r.yesterday_activation_num, r.total_activation_num),
        ratio_yesterday_activity: ratio(r.yesterday_activity_num, r.total_activation_num),
        ratio_activity7: ratio(r.activity7, r.total_activation_num),
        ratio_activity30: ratio(r.activity30, r.total_activation_num),
        tag: r.tag
      }
    end
  end

  def self.tags conditions = nil
    select("distinct tag").where(conditions).order(:tag).map(&:tag).compact
  end

  def self.product_versions conditions = nil
    select("distinct product_version").where(conditions).order(:product_version).map(&:product_version).compact
  end


end
