# -*- encoding : utf-8 -*-
class CreateSdkAliveReports < ActiveRecord::Migration
  def change
    create_table :sdk_alive_reports do |t|
      t.date :report_date
      t.string :tag
      t.integer :activation_num
      t.integer :stay_alive2_num
      t.integer :stay_alive3_num
      t.integer :stay_alive7_num
      t.integer :stay_alive15_num
      t.integer :stay_alive30_num

      t.timestamps
    end
    add_index :sdk_alive_reports, :report_date
    add_index :sdk_alive_reports, :tag
  end
end
