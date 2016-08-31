# -*- encoding : utf-8 -*-
class CreateApkMd5AlarmReports < ActiveRecord::Migration
  def change
    create_table :apk_md5_alarm_reports do |t|
      t.string :tag
      t.date :tag_created_at
      t.integer :user_total_count
      t.integer :abnormal_user_count

      t.timestamps
    end
  end
end
