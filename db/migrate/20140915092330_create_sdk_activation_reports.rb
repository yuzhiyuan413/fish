# -*- encoding : utf-8 -*-
class CreateSdkActivationReports < ActiveRecord::Migration
  def change
    create_table :sdk_activation_reports do |t|
      t.date :report_date
      t.string :tag
      t.integer :activation_num

      t.timestamps
    end
    add_index :sdk_activation_reports, :report_date
    add_index :sdk_activation_reports, :tag
  end
end
