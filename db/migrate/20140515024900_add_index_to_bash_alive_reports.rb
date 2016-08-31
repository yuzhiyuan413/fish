# -*- encoding : utf-8 -*-
class AddIndexToBashAliveReports < ActiveRecord::Migration
  def change
  	add_index :bash_alive_reports, :report_time
    add_index :bash_alive_reports, :tag
  end
end
