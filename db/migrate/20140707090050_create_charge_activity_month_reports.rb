# -*- encoding : utf-8 -*-
class CreateChargeActivityMonthReports < ActiveRecord::Migration
  def change
    create_table :charge_activity_month_reports do |t|
      t.string :report_date
      t.integer :activity_num
      t.integer :request_times
      t.float :request_per_avg
      t.integer :cmcc_num
      t.integer :cucc_num
      t.integer :ctcc_num
      t.integer :others_sp_num
      t.string :tag
      t.string :province

      t.timestamps
    end
  end
end
