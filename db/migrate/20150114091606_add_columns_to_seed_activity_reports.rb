# -*- encoding : utf-8 -*-
class AddColumnsToSeedActivityReports < ActiveRecord::Migration
  def change
    add_column :seed_activity_reports, :v9_activity_num, :integer
    add_column :seed_activity_reports, :v9_activation_num, :integer
    add_column :seed_activity_reports, :v9_request_num, :integer
  end
end
