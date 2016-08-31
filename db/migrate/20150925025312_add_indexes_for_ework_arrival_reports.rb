# -*- encoding : utf-8 -*-
class AddIndexesForEworkArrivalReports < ActiveRecord::Migration
  def change
    add_index :ework_arrival_reports, :report_date
    add_index :ework_arrival_reports, :tag
  end
end
