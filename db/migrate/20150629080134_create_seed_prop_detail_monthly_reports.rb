# -*- encoding : utf-8 -*-
class CreateSeedPropDetailMonthlyReports < ActiveRecord::Migration
  def change
    create_table :seed_prop_detail_monthly_reports do |t|
      t.string :report_date
      t.string :tag
      t.string :board
      t.string :manufacturer
      t.integer :count
      t.float :proportion_ratio
      t.integer :success_count
      t.float :success_ratio
      t.float :succ_proportion_ratio

      t.timestamps
    end
    add_index :seed_prop_detail_monthly_reports, :report_date
    add_index :seed_prop_detail_monthly_reports, :tag
    add_index :seed_prop_detail_monthly_reports, :manufacturer
    add_index :seed_prop_detail_monthly_reports, :board
  end
end
