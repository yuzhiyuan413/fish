# -*- encoding : utf-8 -*-
class Ework::ConversionReport < ActiveRecord::Base
  # attr_accessible :app_activation, :download_jar, :download_jar_ratio, :get_url, :get_url_ratio, :launch_jar, :launch_jar_ratio, :merge_jar, :merge_jar_ratio, :report_date, :seed_active, :seed_active_ratio, :seed_executed, :seed_executed_ratio, :tag
  establish_connection Rails.env.to_sym
  attr_accessor :from_date, :end_date

  def search
    conditions = {:report_date => from_date..end_date}
    conditions[:tag] = System::TagGroup.tag_adaptor(Ework::ConversionReport, tag) unless tag.eql?(System::TagGroup::TOTAL_OPTION_TAG)
    Ework::ConversionReport.where(conditions).order(:tag, :report_date)
  end

  def conversion_avg records
    return nil if records.blank?
    result = OpenStruct.new
    result.app_activation = records.map(&:app_activation).compact.sum
    result.get_url = records.map(&:get_url).compact.sum
    result.download_jar = records.map(&:download_jar).compact.sum
    result.merge_jar = records.map(&:merge_jar).compact.sum
    result.launch_jar = records.map(&:launch_jar).compact.sum
    result.seed_active = records.map(&:seed_active).compact.sum
    result.seed_executed = records.map(&:seed_executed).compact.sum
    result.seed_active_aid = records.map(&:seed_active_aid).compact.sum
    result.seed_executed_aid = records.map(&:seed_executed_aid).compact.sum
    result.get_url_ratio = (result.get_url.to_f/result.app_activation.to_f)
    result.download_jar_ratio = (result.download_jar.to_f/result.app_activation.to_f)
    result.merge_jar_ratio = (result.merge_jar.to_f/result.app_activation.to_f)
    result.launch_jar_ratio = (result.launch_jar.to_f/result.app_activation.to_f)
    result.seed_active_ratio = (result.seed_active.to_f/result.app_activation.to_f)
    result.seed_executed_ratio = (result.seed_executed.to_f/result.app_activation.to_f)
    result.seed_active_aid_ratio = (result.seed_active_aid.to_f/result.app_activation.to_f)
    result.seed_executed_aid_ratio = (result.seed_executed_aid.to_f/result.app_activation.to_f)
    result
  end

  def self.tags conditions = nil
    select("distinct tag").where(conditions).order(:tag).map(&:tag).compact
  end

  def self.conversion_avg column_name
    select("tag, sum(#{column_name})/sum(app_activation) as avg_val").group("tag").order("avg_val");
  end
end
