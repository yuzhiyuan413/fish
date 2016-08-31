# -*- encoding : utf-8 -*-
class AddIndexesForBeeReports < ActiveRecord::Migration
  def change
    add_index :apk_md5_alarm_reports, :tag

    add_index :activity_situation_reports, :report_type
    add_index :activity_situation_reports, :record_time
    add_index :activity_situation_reports, :tag

    add_index :activity_total_reports, :report_type
    add_index :activity_total_reports, :tag 
  end
end
