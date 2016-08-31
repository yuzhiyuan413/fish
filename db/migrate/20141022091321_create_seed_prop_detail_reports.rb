# -*- encoding : utf-8 -*-
class CreateSeedPropDetailReports < ActiveRecord::Migration
  def change
    create_table :seed_prop_detail_reports do |t|
      t.date :report_date
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
    add_index :seed_prop_detail_reports, :report_date
    add_index :seed_prop_detail_reports, :tag
    add_index :seed_prop_detail_reports, :manufacturer
    add_index :seed_prop_detail_reports, :board
  end
end
