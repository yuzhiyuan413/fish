# -*- encoding : utf-8 -*-
class Seed::ActivitySituationReport < ActiveRecord::Base
  attr_accessible :record_time, :activation_num, :activity_num, :avg_request_times, :report_type, :request_times, :tag
  self.table_name = :activity_situation_reports
  include RatioHelper
  def situation_reports
    items = %w{今日 昨日此时 昨日全天}
    situation_reports = []
    items.each do |item|
      if report_type.eql?('1')
        where_causes = {:tag => tag, :report_type => Seed::ActivityReport.to_s, :record_time => item }
        situation_reports << Seed::ActivitySituationReport.where(where_causes).first
      else
        where_causes = {:tag => tag, :product_version => '9.0', :record_time => item }
        situation_reports << Charge::SituationReport.where(where_causes).first
      end
    end
    situation_reports
  end

  def total_report
    if report_type.eql?('1')
      where_causes = {:tag => tag, :report_type => Seed::ActivityReport.to_s}
      records = Seed::ActivityTotalReport.where(where_causes)
      records.map do |r|
        { report_type: r.report_type,
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
    else
      where_causes = {:tag => tag, :product_version => '9.0'}
      Charge::SituationReport.where(where_causes)
    end
  end


  def self.tags conditions = nil
    select("distinct tag").where(conditions).order(:tag).map(&:tag).compact
  end
end
