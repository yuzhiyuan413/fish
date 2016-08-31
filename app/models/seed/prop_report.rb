# -*- encoding : utf-8 -*-
class Seed::PropReport < ActiveRecord::Base
  # attr_accessible :count, :manufacturer, :ratio, :report_date, :tag
  establish_connection Rails.env.to_sym
  attr_accessor :from_date, :end_date

  def search
    conditions = {:report_date => from_date..end_date}
    conditions[:tag] = System::TagGroup.tag_adaptor(Seed::PropReport, tag) unless tag.eql?(System::TagGroup::TOTAL_OPTION_TAG)
    Seed::PropReport.where(conditions).order(:tag, :report_date, :manufacturer)
  end

  def self.tags conditions = nil
    select("distinct tag").where(conditions).order(:tag).map(&:tag).compact
  end

end
