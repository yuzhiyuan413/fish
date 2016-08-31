# -*- encoding : utf-8 -*-
class CreateChargeAliveReports < ActiveRecord::Migration
  def change
    create_table :charge_alive_reports do |t|
      t.date :report_date
      t.integer :activation_num
      t.integer :stay_alive2_num
      t.integer :stay_alive3_num
      t.integer :stay_alive7_num
      t.integer :stay_alive15_num
      t.integer :stay_alive30_num
      t.string :tag
      t.string :product_version

      t.timestamps
    end
  end
end
