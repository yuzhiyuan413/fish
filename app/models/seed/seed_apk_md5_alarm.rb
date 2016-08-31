# -*- encoding : utf-8 -*-
class Seed::SeedApkMd5Alarm < ActiveRecord::Base
  establish_connection "dwh_smart_#{Rails.env}".to_sym
  self.table_name = :seed_apk_md5_alarms
  attr_accessor :from_date, :end_date

  def search
    select_columns = ["md5", "count(distinct uid) uid_count"]
    conditions = {:tag => tag,
                  :record_time => Date.parse(from_date).beginning_of_day..Date.parse(end_date).end_of_day}
    group_columns = [:md5]
    Seed::SeedApkMd5Alarm.select(select_columns).where(conditions).group(group_columns)
  end

  def sum_record records
    return nil if records.blank?
    OpenStruct.new({
      records_size: records.length,
      uid_count: records.map(&:uid_count).compact.sum
    })
  end


  def self.tags conditions = nil
    ApkMd5AlarmReport.tags(conditions)
  end

end
