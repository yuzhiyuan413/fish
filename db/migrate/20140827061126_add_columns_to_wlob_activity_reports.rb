# -*- encoding : utf-8 -*-
class AddColumnsToWlobActivityReports < ActiveRecord::Migration
  def change
    add_column :wlob_activity_reports, :activity_num1, :integer
    add_column :wlob_activity_reports, :request_times1, :integer
    add_column :wlob_activity_reports, :request_per_avg1, :float

    add_column :wlob_activity_reports, :activity_num2, :integer
    add_column :wlob_activity_reports, :request_times2, :integer
    add_column :wlob_activity_reports, :request_per_avg2, :float

    add_column :wlob_activity_reports, :activity_num3, :integer
    add_column :wlob_activity_reports, :request_times3, :integer
    add_column :wlob_activity_reports, :request_per_avg3, :float

    add_column :wlob_activity_reports, :activity_num4, :integer
    add_column :wlob_activity_reports, :request_times4, :integer
    add_column :wlob_activity_reports, :request_per_avg4, :float

    add_column :wlob_activity_reports, :activity_num5, :integer
    add_column :wlob_activity_reports, :request_times5, :integer
    add_column :wlob_activity_reports, :request_per_avg5, :float

  end
end
