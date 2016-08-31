# -*- encoding : utf-8 -*-
class CreateActivityTotalReports < ActiveRecord::Migration
  def change
    create_table :activity_total_reports do |t|
      t.string :report_type
      t.string :tag
      t.integer :total_activation_num
      t.integer :yesterday_activation_num
      t.integer :yesterday_activity_num
      t.integer :activity7
      t.integer :activity30

      t.timestamps
    end
  end
end
