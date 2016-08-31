# -*- encoding : utf-8 -*-
class AddProductVersionToChargeActivityMonthReports < ActiveRecord::Migration
  def change
    add_column :charge_activity_month_reports, :product_version, :string
  end
end
