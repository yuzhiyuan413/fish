class ChargeDs::ReportUser < ActiveRecord::Base
  establish_connection "dwh_crab_#{Rails.env}".to_sym
  self.table_name = :charge_users

  def self.count_activation date, tag, product_version
    conditions = {}
    conditions[:activation_time] = (date.beginning_of_day..date.end_of_day)
    conditions[:tag] = tag unless tag == "全部标签"
    conditions[:loader_version_short] = product_version unless product_version == "全部版本"
    select("distinct uuid").where(conditions).count
  end

  def self.stay_alive_records activation_date, stay_alive_date, group_columns
    select_columns = ["count(distinct report_users.uuid) stay_alive_num"] + group_columns
    join_clause = "inner join report_request_histories on report_users.uuid = report_request_histories.uuid"
    conditions = {
      "report_request_histories.request_time" => (stay_alive_date.beginning_of_day..stay_alive_date.end_of_day),
      "report_users.activation_time" => (activation_date.beginning_of_day..activation_date.end_of_day)
    }
    select(select_columns).joins(join_clause).where(conditions).group(group_columns)
  end

  def self.group_activation_by begin_time, end_time, group_columns
    conditions = {:activation_time => (begin_time..end_time)}
    select(["count(distinct uuid) activation_num"] + group_columns).where(conditions).group(group_columns)
  end

  def self.group_activation_v9 begin_time, end_time, group_columns
    conditions = {:activation_time => (begin_time..end_time), :loader_version_short => "9.0" }
    select(["count(distinct uuid) activation_num"] + group_columns).where(conditions).group(group_columns)
  end

  def self.count_activation_v9 tag, begin_time, end_time = begin_time.end_of_day
    conditions = {}
    conditions[:activation_time] = (begin_time..end_time)
    conditions[:tag] = tag unless tag == System::TagGroup::TOTAL_SUM_TAG
    conditions[:loader_version_short] = '9.0'
    select("distinct uuid").where(conditions).count
  end

  def self.group_total_activation_by group_columns
    select(["count(distinct uuid) activation_num"] + group_columns).group(group_columns)
  end

end
