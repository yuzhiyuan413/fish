# -*- encoding : utf-8 -*-
class CreateChargeTotalReports < ActiveRecord::Migration
  def change
    create_table :charge_total_reports do |t|
      t.string :tag
      t.string :product_version
      t.integer :total_activation_num
      t.integer :yesterday_activation_num
      t.integer :yesterday_activity_num
      t.integer :activity7
      t.integer :activity30

      t.timestamps
    end
  end
end
