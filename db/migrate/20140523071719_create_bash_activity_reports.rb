# -*- encoding : utf-8 -*-
class CreateBashActivityReports < ActiveRecord::Migration
  def change
    create_table :bash_activity_reports do |t|
    	t.string :tag
    	t.integer :activity_num
      t.integer :activation_num
    	t.integer :request_num
    	t.date :report_time
      t.timestamps
    end
    add_index :bash_activity_reports, :report_time
    add_index :bash_activity_reports, :tag
  end
end
