# -*- encoding : utf-8 -*-
class CreateChargeSituationReports < ActiveRecord::Migration
  def change
    create_table :charge_situation_reports do |t|
      t.string :tag
      t.string :product_version
      t.integer :activation_num
      t.integer :activity_num
      t.integer :request_times
      t.float :avg_request_times
      t.string :record_time

      t.timestamps
    end
  end
end
