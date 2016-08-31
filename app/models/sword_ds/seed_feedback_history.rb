class SwordDs::SeedFeedbackHistory < ActiveRecord::Base
  establish_connection "dwh_sword_#{Rails.env}".to_sym
  self.table_name = :seed_feedback_histories
  PLAN_CACHE_KEY = 'solution_lost_plan'

  def self.plan_options
    Rails.cache.exist?(PLAN_CACHE_KEY) ?
      Rails.cache.read(PLAN_CACHE_KEY) :
        plan_maps
  end

  def self.plan_maps
    plan_ids = select(["distinct solution_id"]).where(
      "record_time > '#{7.days.ago.strftime("%F %T")}'").map(&:solution_id).compact.sort
    plan_ids.unshift("全部方案")
    Rails.cache.write(PLAN_CACHE_KEY, plan_ids)
    plan_ids
  end

  def self.event_records_by_tag_group(tag, event_name, begin_time, end_time, condition = nil)
    select_columns = [:solution_id, "count(distinct did) did_count"]
    conditions = {:record_time => (begin_time..end_time), :event_name => event_name }
    conditions[:tag] = tag unless tag.eql? System::TagGroup::TOTAL_SUM_TAG
    group_columns = [:solution_id]
    select(select_columns).where(conditions).where(condition).group(group_columns)
  end

  def self.event_records(event_name, begin_time, end_time, condition = nil)
    select_columns = [:tag, "count(distinct did) did_count", :solution_id]
    conditions = {:record_time => (begin_time..end_time), :event_name => event_name }
    group_columns = [:tag, :solution_id]
    select(select_columns).where(conditions).where(condition).group(group_columns)
  end

  def self.count_event_sum_by_tag_group(tag, event_name, begin_time, end_time, condition = nil)
    select_columns = ["distinct did"]
    conditions = {:record_time => (begin_time..end_time), :event_name => event_name }
    conditions[:tag] = tag unless tag.eql? System::TagGroup::TOTAL_SUM_TAG
    select(select_columns).where(conditions).where(condition).count
  end

  def self.event_sum_records(event_name, begin_time, end_time, condition = nil)
    select_columns = [:tag, "count(distinct did) did_count"]
    conditions = {:record_time => (begin_time..end_time), :event_name => event_name }
    group_columns = [:tag]
    select(select_columns).where(conditions).where(condition).group(group_columns)
  end



  def self.device_detail_records(begin_time, end_time)
    select_columns = [:tag, :brand, :model, "count(distinct did) did_count", ]
    conditions = {:record_time => (begin_time..end_time)}
    group_columns = [:tag, :brand, :model]
    select(select_columns).where(conditions).group(group_columns)
  end

  def self.device_detail_records_by_tag_group(tag, begin_time, end_time)
    select_columns = [:brand, :model, "count(distinct did) did_count"]
    conditions = {:record_time => (begin_time..end_time)}
    conditions[:tag] = tag unless tag.eql? System::TagGroup::TOTAL_SUM_TAG
    group_columns = [:brand, :model]
    select(select_columns).where(conditions).group(group_columns)
  end

  def self.count_device_sum_by_tag_group(tag, begin_time, end_time)
    conditions = {:record_time => (begin_time..end_time)}
    conditions[:tag] = tag unless tag.eql? System::TagGroup::TOTAL_SUM_TAG
    select("distinct did").where(conditions).count
  end

  def self.device_sum_records(begin_time, end_time)
    select_columns = [:tag, "count(distinct did) did_count"]
    conditions = {:record_time => (begin_time..end_time)}
    group_columns = [:tag]
    select(select_columns).where(conditions).group(group_columns)
  end

  def self.device_detail_succ_records(begin_time, end_time)
    select_columns = [:tag, :brand, :model, "count(distinct did) did_count"]
    conditions = {
      "record_time" => (begin_time..end_time),
      "event_name" => 'solution_executed',
      "excuted_status" => 'Success'
    }
    group_columns = [:tag, :brand, :model]
    select(select_columns).where(conditions).group(group_columns)
  end

  def self.device_detail_succ_records_by_tag_group(tag, begin_time, end_time)
    select_columns = [:brand, :model, "count(distinct did) did_count"]

    conditions = {
      "record_time" => (begin_time..end_time),
      "event_name" => 'solution_executed',
      "excuted_status" => 'Success'
    }
    conditions[:tag] = tag unless tag.eql? System::TagGroup::TOTAL_SUM_TAG
    group_columns = [:brand, :model]
    select(select_columns).where(conditions).group(group_columns)
  end

  def self.count_device_succ_sum_by_tag_group(tag, begin_time, end_time)
    conditions = {
      "record_time" => (begin_time..end_time),
      "event_name" => 'solution_executed',
      "excuted_status" => 'Success'
    }
    conditions[:tag] = tag unless tag.eql? System::TagGroup::TOTAL_SUM_TAG
    select("distinct did").where(conditions).count
  end

  def self.device_succ_sum_records(begin_time, end_time)
    select_columns = [:tag, "count(distinct did) did_count"]
    conditions = {
      "record_time" => (begin_time..end_time),
      "event_name" => 'solution_executed',
      "excuted_status" => 'Success',
    }
    group_columns = [:tag]
    select(select_columns).where(conditions).group(group_columns)
  end

end
