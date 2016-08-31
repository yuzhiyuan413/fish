# -*- encoding : utf-8 -*-
class Seed::ActivityTotalReport < ActiveRecord::Base
  attr_accessible :activity30, :activity7, :report_type, :tag, :total_activation_num, :yesterday_activation_num, :yesterday_activity_num
  self.table_name = :activity_total_reports

  def self.tags conditions = nil
    select("distinct tag").where(conditions).order(:tag).map(&:tag).compact
  end
end
