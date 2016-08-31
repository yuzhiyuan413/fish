# -*- encoding : utf-8 -*-
class Seed::PropDetailMonthlyReport < ActiveRecord::Base
  #attr_accessible :board, :count, :manufacturer, :proportion_ratio, :report_date, :succ_proportion_ratio, :success_count, :success_ratio, :tag
  establish_connection Rails.env.to_sym

  def search
    conditions = {:report_date => report_date}
    conditions[:tag] = System::TagGroup.tag_adaptor(Seed::PropDetailMonthlyReport, tag) unless tag.eql?(System::TagGroup::TOTAL_OPTION_TAG)
    conditions[:manufacturer] = manufacturer unless manufacturer.eql? "全部厂商"
    conditions[:board] = board unless board.eql? "全部型号"
    Seed::PropDetailMonthlyReport.where(conditions).order(:tag, :manufacturer, :board)
  end

  def self.manufacturers
    select("distinct manufacturer").order(:manufacturer => :desc).map(&:manufacturer).compact
  end

  def self.boards
    select("distinct board").order(:board => :desc).map(&:board).compact
  end

  def self.tags conditions = nil
    select("distinct tag").where(conditions).order(:tag).map(&:tag).compact
  end

end
