# -*- encoding : utf-8 -*-
class AddColumnToSeedActivationReports < ActiveRecord::Migration
  def change
  	add_column :seed_activation_reports, :reset_num, :integer
  	add_column :seed_activation_reports, :reset_num_ratio, :float
  end
end
