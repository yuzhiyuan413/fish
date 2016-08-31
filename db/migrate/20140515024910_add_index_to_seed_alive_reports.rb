# -*- encoding : utf-8 -*-
class AddIndexToSeedAliveReports < ActiveRecord::Migration
  def change
  	add_index :seed_alive_reports, :report_time
    add_index :seed_alive_reports, :tag
  end
end
