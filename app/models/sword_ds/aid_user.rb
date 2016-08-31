class SwordDs::AidUser < ActiveRecord::Base
  establish_connection "dwh_sword_#{Rails.env}".to_sym

  def self.activation_records begin_time, end_time
    select_clause = ["tag","count(distinct aid) uid_count"]
    conditions = {:record_time => (begin_time..end_time) }
    group_columns = [:tag]
    select(select_clause).where(conditions).group(group_columns)
  end

  def self.count_activation tag, begin_time, end_time
    conditions = {:record_time => (begin_time..end_time) }
    conditions[:tag] = tag unless tag.eql?(System::TagGroup::TOTAL_SUM_TAG)
    select("distinct aid").where(conditions).count
  end

  def self.cross_solution_event_records event_name, begin_time, end_time, condition=nil
    select_clause = ["aid_users.tag","count(distinct aid_users.aid) uid_count"]
    conditions = {"aid_users.record_time" => (begin_time..end_time) }
    where_clause1 = ["sword_production.seed_feedback_histories.record_time > ?", begin_time]
    where_clause2 = ["sword_production.seed_feedback_histories.event_name = ?", event_name]
    join_clause = "inner join sword_production.seed_feedback_histories on
      sword_production.seed_feedback_histories.aid = aid_users.aid"
    group_columns = ["aid_users.tag"]
    select(select_clause).joins(join_clause).where(conditions).where(
      where_clause1).where(where_clause2).where(condition).group(group_columns)
  end

  def self.count_cross_solution_event tag, event_name, begin_time, end_time, condition=nil
    select_clause = ["distinct aid_users.aid"]
    conditions = {"aid_users.record_time" => (begin_time..end_time) }
    conditions["aid_users.tag"] = tag unless tag.eql?(System::TagGroup::TOTAL_SUM_TAG)
    where_clause1 = ["sword_production.seed_feedback_histories.record_time > ?", begin_time]
    where_clause2 = ["sword_production.seed_feedback_histories.event_name = ?", event_name]
    join_clause = "inner join sword_production.seed_feedback_histories on
    sword_production.seed_feedback_histories.aid = aid_users.aid"
    select(select_clause).joins(join_clause).where(conditions).where(
    where_clause1).where(where_clause2).where(condition).count
  end

  def self.cross_v9_activity_records begin_time, end_time
    select_clause = ["aid_users.tag","count(distinct aid_users.aid) uid_count"]
    conditions = {"aid_users.record_time" => (begin_time..end_time) }
    where_clause1 = ["smart_production.request_histories.record_time > ?", begin_time]
    join_clause = "inner join smart_production.request_histories on
    smart_production.request_histories.aid = aid_users.aid"
    group_columns = ["aid_users.tag"]
    select(select_clause).joins(join_clause).where(conditions).where(
    where_clause1).group(group_columns)
  end

  def self.count_cross_v9_activity tag, begin_time, end_time
    select_clause = ["distinct aid_users.aid"]
    conditions = {"aid_users.record_time" => (begin_time..end_time) }
    conditions["aid_users.tag"] = tag unless tag.eql?(System::TagGroup::TOTAL_SUM_TAG)
    where_clause1 = ["smart_production.request_histories.record_time > ?", begin_time]
    join_clause = "inner join smart_production.request_histories on
    smart_production.request_histories.aid = aid_users.aid"
    select(select_clause).joins(join_clause).where(conditions).where(
    where_clause1).count
  end

end
