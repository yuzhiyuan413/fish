# -*- encoding : utf-8 -*-
class CreateChargeActivationReports < ActiveRecord::Migration
  def change
    create_table :charge_activation_reports do |t|
      t.date :report_date
      t.integer :activation_num
      t.string :tag
      t.string :product_version

      t.timestamps
    end
  end
end
