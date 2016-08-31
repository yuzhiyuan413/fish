# -*- encoding : utf-8 -*-
class EworkDs::TPhonearg < ActiveRecord::Base
  establish_connection "dwh_ework_#{Rails.env}".to_sym

  def self.activation_records begin_time, end_time = begin_time.end_of_day
    select_clause = ["tag","count(distinct uid) uid_count"]
    conditions = {:first_time => (begin_time..end_time) }
    group_columns = [:tag]
    select(select_clause).where(conditions).group(group_columns)
  end

  def self.count_activation tag, begin_time, end_time = begin_time.end_of_day
    conditions = {:first_time => (begin_time..end_time) }
    conditions[:tag] = tag unless tag.eql?(System::TagGroup::TOTAL_SUM_TAG)
    select("distinct uid").where(conditions).count
  end

  def self.conversion_records begin_time, end_time = begin_time.end_of_day
    select_clause = ["tag","count(uid) app_activation","sum(url_success) get_url",
      "sum(down_success) download_jar","sum(merge_success) merge_jar",
      "sum(run_success) launch_jar"]
    conditions = {:first_time => (begin_time..end_time) }
    group_columns = [:tag]
    select(select_clause).where(conditions).group(group_columns)
  end

  def self.count_conversion tag, begin_time, end_time = begin_time.end_of_day
    select_clause = ["count(uid) app_activation","sum(url_success) get_url",
      "sum(down_success) download_jar","sum(merge_success) merge_jar",
      "sum(run_success) launch_jar"]
    conditions = {:first_time => (begin_time..end_time) }
    conditions[:tag] = tag unless tag.eql?(System::TagGroup::TOTAL_SUM_TAG)
    select(select_clause).where(conditions)
  end

  def self.count_seed_event_cross_ework tag, event_name, begin_time, end_time
    select_columns = ["distinct t_phoneargs.uid"]
    conditions = {"t_phoneargs.first_time" => (begin_time..end_time)}
    where_clause = ["sword_production.seed_feedback_histories.event_name = ?", event_name]
    where_clause2 = ["t_phoneargs.tag in (?)", tag]
    where_clause3 = ["sword_production.seed_feedback_histories.tag in (?)", tag]
    join_clause = "inner join sword_production.seed_feedback_histories on
      sword_production.seed_feedback_histories.aid = t_phoneargs.uid"
    select(select_columns).joins(join_clause).where(conditions).where(where_clause).where(where_clause2).where(where_clause3).count
  end

  def self.seed_event_records event_name, begin_time, end_time
    select_columns = ["t_phoneargs.tag", "count(distinct uid) uid_count"]
    conditions = {"t_phoneargs.first_time" => (begin_time..end_time) }
    where_clause = ["sword_production.seed_feedback_histories.event_name = ?", event_name]
    group_columns = ["t_phoneargs.tag"]
    join_clause = "inner join sword_production.seed_feedback_histories on
      sword_production.seed_feedback_histories.aid = t_phoneargs.uid"
    select(select_columns).joins(join_clause).where(conditions).where(where_clause).group(group_columns)
  end

  def self.cross_solution_event_records event_name, begin_time, end_time, condition=nil
    select_clause = ["t_phoneargs.tag","count(distinct t_phoneargs.uid) uid_count"]
    conditions = {"t_phoneargs.first_time" => (begin_time..end_time) }
    where_clause1 = ["sword_production.seed_feedback_histories.record_time > ?", begin_time]
    where_clause2 = ["sword_production.seed_feedback_histories.event_name = ?", event_name]
    join_clause = "inner join sword_production.seed_feedback_histories on
      sword_production.seed_feedback_histories.aid = t_phoneargs.uid"
    group_columns = ["t_phoneargs.tag"]
    select(select_clause).joins(join_clause).where(conditions).where(
      where_clause1).where(where_clause2).where(condition).group(group_columns)
  end

  def self.count_cross_solution_event tag, event_name, begin_time, end_time, condition=nil
    select_clause = ["distinct t_phoneargs.uid"]
    conditions = {"t_phoneargs.first_time" => (begin_time..end_time) }
    conditions["t_phoneargs.tag"] = tag unless tag.eql?(System::TagGroup::TOTAL_SUM_TAG)
    where_clause1 = ["sword_production.seed_feedback_histories.record_time > ?", begin_time]
    where_clause2 = ["sword_production.seed_feedback_histories.event_name = ?", event_name]
    join_clause = "inner join sword_production.seed_feedback_histories on
    sword_production.seed_feedback_histories.aid = t_phoneargs.uid"
    select(select_clause).joins(join_clause).where(conditions).where(
    where_clause1).where(where_clause2).where(condition).count
  end

  def self.cross_v9_activity_records begin_time, end_time = begin_time.end_of_day
    select_clause = ["t_phoneargs.tag","count(distinct t_phoneargs.uid) uid_count"]
    conditions = {"t_phoneargs.first_time" => (begin_time..end_time) }
    where_clause1 = ["smart_production.request_histories.record_time > ?", begin_time]
    where_clause2 = ["substring_index(smart_production.request_histories.loader_version,'.',1) = '9'"]
    join_clause = "inner join smart_production.request_histories on
    smart_production.request_histories.aid = t_phoneargs.uid"
    group_columns = ["t_phoneargs.tag"]
    select(select_clause).joins(join_clause).where(conditions).where(
    where_clause1).where(where_clause2).group(group_columns)
  end

  def self.count_cross_v9_activity tag, begin_time, end_time = begin_time.end_of_day
    select_clause = ["distinct t_phoneargs.uid"]
    conditions = {"t_phoneargs.first_time" => (begin_time..end_time) }
    conditions["t_phoneargs.tag"] = tag unless tag.eql?(System::TagGroup::TOTAL_SUM_TAG)
    where_clause1 = ["smart_production.request_histories.record_time > ?", begin_time]
    where_clause2 = ["substring_index(smart_production.request_histories.loader_version,'.',1) = '9'"]
    join_clause = "inner join smart_production.request_histories on
    smart_production.request_histories.aid = t_phoneargs.uid"
    select(select_clause).joins(join_clause).where(conditions).where(
    where_clause1).where(where_clause2).count
  end


end
