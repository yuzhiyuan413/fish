class AddColumnNewInstalledToSeedSolutionReports < ActiveRecord::Migration
  def change
  	add_column :seed_solution_reports, :new_installed_count, :integer
    add_column :seed_solution_reports, :new_installed_ratio, :float
  end
end
