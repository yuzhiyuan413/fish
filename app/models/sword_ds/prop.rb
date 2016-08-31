class SwordDs::Prop < ActiveRecord::Base
#event_id, guid, uuid, imsi1, imei1, mem_total, data_free_space, system_free_space, linux_v, tag, pkgn, sv, did, apil, record_time, ro_pd_manufacturer, ro_pd_model, ro_pd_brand, ro_pd_device, ro_pd_name, ro_pd_cpu_abi, ro_pd_cpu_abi2, ro_pd_ship, ro_pd_locale_region, ro_pd_locale_language, ro_pd_board, trigger_time
  establish_connection "dwh_sword_#{Rails.env}".to_sym

  def self.prop_records_by_tag_group(tag, begin_time, end_time)
    select_columns = [:ro_pd_brand, "count(distinct did) did_count"]
    conditions = {:record_time => (begin_time..end_time)}
    conditions[:tag] = tag unless tag.compact.blank?
    group_columns = [:ro_pd_brand]
    select(select_columns).where(conditions).group(group_columns)
  end

  def self.prop_records(begin_time, end_time)
    select_columns = [:tag, :ro_pd_brand, "count(distinct did) did_count"]
    conditions = {:record_time => (begin_time..end_time)}
    group_columns = [:tag, :ro_pd_brand]
    select(select_columns).where(conditions).group(group_columns)
  end

  def self.prop_detail_records_by_tag_group(tag, begin_time, end_time)
    select_columns = [:ro_pd_brand, :ro_pd_model, "count(distinct did) did_count"]
    conditions = {:record_time => (begin_time..end_time)}
    conditions[:tag] = tag unless tag.compact.blank?
    group_columns = [:ro_pd_brand, :ro_pd_model]
    select(select_columns).where(conditions).group(group_columns)
  end

  def self.prop_detail_records(begin_time, end_time)
    select_columns = [:tag, :ro_pd_brand, :ro_pd_model, "count(distinct did) did_count", ]
    conditions = {:record_time => (begin_time..end_time)}
    group_columns = [:tag, :ro_pd_brand, :ro_pd_model]
    select(select_columns).where(conditions).group(group_columns)
  end

  def self.count_prop_sum_by_tag_group(tag, begin_time, end_time)
    conditions = {:record_time => (begin_time..end_time)}
    conditions[:tag] = tag unless tag.compact.blank?
    select("distinct did").where(conditions).count
  end

  def self.prop_sum_records(begin_time, end_time)
    select_columns = [:tag, "count(distinct did) did_count"]
    conditions = {:record_time => (begin_time..end_time)}
    group_columns = [:tag]
    select(select_columns).where(conditions).group(group_columns)
  end


  def self.prop_succ_records(begin_time, end_time)
    select_columns = ["props.tag", "props.ro_pd_brand", "count(distinct seed_feedback_histories.did) did_count"]
    join_clause = "inner join seed_feedback_histories on props.did = seed_feedback_histories.did"
    conditions = {
      "props.record_time" => (begin_time..end_time),
      "seed_feedback_histories.record_time" => (begin_time..end_time),
      "seed_feedback_histories.event_name" => 'solution_executed',
      "seed_feedback_histories.excuted_status" => 'Success',
    }
    group_columns = ["props.tag", "props.ro_pd_brand"]
    select(select_columns).joins(join_clause).where(conditions).group(group_columns)
  end

  def self.prop_detail_succ_records(begin_time, end_time)
    select_columns = ["props.tag", "props.ro_pd_brand", "props.ro_pd_model", "count(distinct seed_feedback_histories.did) did_count"]
    join_clause = "inner join seed_feedback_histories on props.did = seed_feedback_histories.did"
    conditions = {
      "props.record_time" => (begin_time..end_time),
      "seed_feedback_histories.record_time" => (begin_time..end_time),
      "seed_feedback_histories.event_name" => 'solution_executed',
      "seed_feedback_histories.excuted_status" => 'Success',
    }
    group_columns = ["props.tag", "props.ro_pd_brand", "props.ro_pd_model"]
    select(select_columns).joins(join_clause).where(conditions).group(group_columns)
  end

  def self.prop_succ_records_by_tag_group(tag, begin_time, end_time)
    select_columns = ["props.ro_pd_brand", "count(distinct seed_feedback_histories.did) did_count"]
    join_clause = "inner join seed_feedback_histories on props.did = seed_feedback_histories.did"
    conditions = {
      "props.record_time" => (begin_time..end_time),
      "seed_feedback_histories.record_time" => (begin_time..end_time),
      "seed_feedback_histories.event_name" => 'solution_executed',
      "seed_feedback_histories.excuted_status" => 'Success',
    }
    conditions["props.tag"] = tag unless tag.compact.blank?
    group_columns = ["props.ro_pd_brand"]
    select(select_columns).joins(join_clause).where(conditions).group(group_columns)
  end

  def self.prop_detail_succ_records_by_tag_group(tag, begin_time, end_time)
    select_columns = ["props.ro_pd_brand", "props.ro_pd_model", "count(distinct seed_feedback_histories.did) did_count"]
    join_clause = "inner join seed_feedback_histories on props.did = seed_feedback_histories.did"
    conditions = {
      "props.record_time" => (begin_time..end_time),
      "seed_feedback_histories.record_time" => (begin_time..end_time),
      "seed_feedback_histories.event_name" => 'solution_executed',
      "seed_feedback_histories.excuted_status" => 'Success',
    }
    conditions["props.tag"] = tag unless tag.compact.blank?
    group_columns = ["props.ro_pd_brand", "props.ro_pd_model"]
    select(select_columns).joins(join_clause).where(conditions).group(group_columns)
  end

  def self.count_prop_succ_sum_by_tag_group(tag, begin_time, end_time)
    join_clause = "inner join seed_feedback_histories on props.did = seed_feedback_histories.did"
    conditions = {
      "props.record_time" => (begin_time..end_time),
      "seed_feedback_histories.record_time" => (begin_time..end_time),
      "seed_feedback_histories.event_name" => 'solution_executed',
      "seed_feedback_histories.excuted_status" => 'Success',
    }
    conditions["props.tag"] = tag unless tag.compact.blank?
    select("distinct seed_feedback_histories.did").joins(join_clause).where(conditions).count
  end

  def self.prop_succ_sum_records(begin_time, end_time)
    select_columns = ["props.tag", "count(distinct seed_feedback_histories.did) did_count"]
    join_clause = "inner join seed_feedback_histories on props.did = seed_feedback_histories.did"
    conditions = {
      "props.record_time" => (begin_time..end_time),
      "seed_feedback_histories.record_time" => (begin_time..end_time),
      "seed_feedback_histories.event_name" => 'solution_executed',
      "seed_feedback_histories.excuted_status" => 'Success',
    }
    group_columns = ["props.tag"]
    select(select_columns).joins(join_clause).where(conditions).group(group_columns)
  end
end
