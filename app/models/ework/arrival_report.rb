# -*- encoding : utf-8 -*-
class Ework::ArrivalReport < ActiveRecord::Base
  attr_accessor :from_date, :end_date

  def search
    conditions = {:report_date => from_date..end_date}
    conditions[:tag] = System::TagGroup.tag_adaptor(Ework::ArrivalReport, tag) unless tag.eql?(System::TagGroup::TOTAL_OPTION_TAG)
    Ework::ArrivalReport.where(conditions).order(:tag, :report_date)
  end

  def sum_record records
    return nil if records.blank?
    r = OpenStruct.new
    r.ework_activation = records.map(&:ework_activation).compact.sum
    r.seed_active = records.map(&:seed_active).compact.sum
    r.seed_executing = records.map(&:seed_executing).compact.sum
    r.seed_executied = records.map(&:seed_executied).compact.sum
    r.seed_successed = records.map(&:seed_successed).compact.sum
    r.seed_installed = records.map(&:seed_installed).compact.sum
    r.seed_started = records.map(&:seed_started).compact.sum
    r.seed_failed = records.map(&:seed_failed).compact.sum
    r.seed_v8_exists = records.map(&:seed_v8_exists).compact.sum
    r.seed_v9_exists = records.map(&:seed_v9_exists).compact.sum
    r.v9_activity = records.map(&:v9_activity).compact.sum
    r.seed_active_ratio = r.seed_active.to_i/r.ework_activation.to_f
    r.seed_executing_ratio = r.seed_executing.to_i/r.ework_activation.to_f
    r.seed_executied_ratio = r.seed_executied.to_i/r.ework_activation.to_f
    r.seed_successed_ratio = r.seed_successed.to_i/r.ework_activation.to_f
    r.seed_installed_ratio = r.seed_installed.to_i/r.ework_activation.to_f
    r.seed_started_ratio = r.seed_started.to_i/r.ework_activation.to_f
    r.seed_failed_ratio = r.seed_failed.to_i/r.seed_successed.to_f
    r.seed_v8_exists_ratio = r.seed_v8_exists.to_i/r.seed_successed.to_f
    r.seed_v9_exists_ratio = r.seed_v9_exists.to_i/r.seed_successed.to_f
    r.v9_activity_ratio = r.v9_activity.to_i/r.ework_activation.to_f
    r
  end

  def self.tags conditions = nil
    select("distinct tag").where(conditions).order(:tag).map(&:tag).compact
  end
end
