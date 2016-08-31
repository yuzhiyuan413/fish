# -*- encoding : utf-8 -*-
class AddV8V9ExistsToSeedSolutionReports < ActiveRecord::Migration
  def change
    add_column :seed_solution_reports, :v8_exists_count, :integer
    add_column :seed_solution_reports, :v8_exists_ratio, :float
    add_column :seed_solution_reports, :v9_exists_count, :integer
    add_column :seed_solution_reports, :v9_exists_ratio, :float
  end
end
