# -*- encoding : utf-8 -*-
class AddColumnsToSeedSolutionReports < ActiveRecord::Migration
  def change
    add_column :seed_solution_reports, :installed_count, :integer
    add_column :seed_solution_reports, :installed_ratio, :float
  end
end
