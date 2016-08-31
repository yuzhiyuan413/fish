# -*- encoding : utf-8 -*-
class Seed::DeviceDetailReport < ActiveRecord::Base
  #attr_accessible :board, :count, :manufacturer, :ratio, :report_date, :tag
  establish_connection Rails.env.to_sym
  attr_accessor :from_date, :end_date

  def search
    conditions = {:report_date => from_date..end_date}
    conditions[:tag] = System::TagGroup.tag_adaptor(Seed::DeviceDetailReport, tag) unless tag.eql?(System::TagGroup::TOTAL_OPTION_TAG)
    Seed::DeviceDetailReport.where(conditions).order(:tag, :report_date, :model)
  end

  def self.tags conditions = nil
    select("distinct tag").where(conditions).order(:tag).map(&:tag).compact
  end

end
