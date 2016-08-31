# -*- encoding : utf-8 -*-
class AddActiveCountToSeedSolutionReports < ActiveRecord::Migration
  def change
    add_column :seed_solution_reports, :active_count, :integer
  end
end
