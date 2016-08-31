# -*- encoding : utf-8 -*-
class ApkMd5AlarmReport < ActiveRecord::Base
  attr_accessible :abnormal_user_count, :tag, :tag_created_at, :user_total_count
  establish_connection Rails.env.to_sym

  def self.sum_records records
    return nil if records.blank?
    report = ApkMd5AlarmReport.new
    report.user_total_count = records.map(&:user_total_count).compact.sum
    report.abnormal_user_count = records.map(&:abnormal_user_count).compact.sum
    report
  end

  def self.tags conditions = nil
    select("distinct tag").where(conditions).order(:tag).map(&:tag).compact
  end
end
