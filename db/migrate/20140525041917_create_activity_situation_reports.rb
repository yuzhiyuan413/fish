# -*- encoding : utf-8 -*-
class CreateActivitySituationReports < ActiveRecord::Migration
  def change
    create_table :activity_situation_reports do |t|
      t.string :report_type
      t.integer :activation_num
      t.string :tag
      t.integer :activity_num
      t.integer :request_times
      t.float :avg_request_times
      t.string :record_time

      t.timestamps
    end
  end
end
