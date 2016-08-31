# -*- encoding : utf-8 -*-
class CreateSeedPropReports < ActiveRecord::Migration
  def change
    create_table :seed_prop_reports do |t|
      t.date :report_date
      t.string :tag
      t.string :manufacturer
      t.integer :count
      t.float :proportion_ratio
      t.integer :success_count
      t.float :success_ratio
      t.float :succ_proportion_ratio

      t.timestamps
    end
    add_index :seed_prop_reports, :report_date
    add_index :seed_prop_reports, :tag
    add_index :seed_prop_reports, :manufacturer
  end
end
