# -*- encoding : utf-8 -*-
class CreateChargeActivityReports < ActiveRecord::Migration
  def change
    create_table :charge_activity_reports do |t|
      t.date :report_date
      t.integer :activity_num
      t.integer :request_times
      t.float :request_per_avg
      t.integer :cmcc_num
      t.integer :cucc_num
      t.integer :ctcc_num
      t.integer :others_sp_num
      t.string :tag
      t.string :product_version
      t.string :province

      t.timestamps
    end
  end
end
