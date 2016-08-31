# -*- encoding : utf-8 -*-
class CreateWlobActivationReports < ActiveRecord::Migration
  def change
    create_table :wlob_activation_reports do |t|
      t.date :report_date
      t.string :tag
      t.integer :activation_num

      t.timestamps
    end
    add_index :wlob_activation_reports, :report_date
    add_index :wlob_activation_reports, :tag
  end
end
