# -*- encoding : utf-8 -*-
class CreateSeedSolutionReports < ActiveRecord::Migration
  def change
    create_table :seed_solution_reports do |t|
      t.date :report_date
      t.string :tag
      t.integer :plan_id
      t.integer :execting_count
      t.integer :exected_count
      t.integer :canceled_count
      t.integer :success_count
      t.float :success_ratio
      t.float :return_ratio
      t.float :succ_proportion_ratio

      t.timestamps
    end
    add_index :seed_solution_reports, :report_date
    add_index :seed_solution_reports, :tag
    add_index :seed_solution_reports, :plan_id
  end
end
