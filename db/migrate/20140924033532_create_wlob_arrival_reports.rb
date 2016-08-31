# -*- encoding : utf-8 -*-
class CreateWlobArrivalReports < ActiveRecord::Migration
  def change
    create_table :wlob_arrival_reports do |t|
      t.date :report_date
      t.string :tag
      t.integer :arrival_total
      t.integer :arrival_num1
      t.integer :arrival_num2
      t.integer :arrival_num3
      t.integer :arrival_num4
      t.integer :arrival_num5

      t.timestamps
    end
    add_index :wlob_arrival_reports, :report_date
    add_index :wlob_arrival_reports, :tag
  end
end
