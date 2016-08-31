# -*- encoding : utf-8 -*-
class Seed::SolutionReport < ActiveRecord::Base
  # attr_accessible :canceled_count, :exected_count, :execting_count, :plan_id, :report_date, :return_ratio, :success_count, :success_ratio, :tag
  establish_connection Rails.env.to_sym
  attr_accessor :from_date, :end_date

  def search
    conditions = {:report_date => from_date..end_date}
    conditions[:tag] = System::TagGroup.tag_adaptor(Seed::SolutionReport, tag) unless tag.eql?(System::TagGroup::TOTAL_OPTION_TAG)
    Seed::SolutionReport.where(conditions).order(:tag, :report_date, :plan_id)
  end

  def plan_name
  	self.plan_id.eql?(0) ? '汇总' : self.plan_id
  end

  def self.tags conditions = nil
    select("distinct tag").where(conditions).order(:tag).map(&:tag).compact
  end
end
