# -*- encoding : utf-8 -*-
class AddIndexesForChargeReports < ActiveRecord::Migration
  def change
    add_index :charge_activation_reports, :report_date
    add_index :charge_activation_reports, :tag
    add_index :charge_activation_reports, :product_version

    add_index :charge_activity_reports, :report_date
    add_index :charge_activity_reports, :tag
    add_index :charge_activity_reports, :product_version
    add_index :charge_activity_reports, :province

    add_index :charge_activity_month_reports, :report_date
    add_index :charge_activity_month_reports, :tag
    add_index :charge_activity_month_reports, :product_version
    add_index :charge_activity_month_reports, :province

    add_index :charge_alive_reports, :report_date
    add_index :charge_alive_reports, :tag
    add_index :charge_alive_reports, :product_version

  end
end
