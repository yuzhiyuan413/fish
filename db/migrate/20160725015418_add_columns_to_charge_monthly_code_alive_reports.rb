class AddColumnsToChargeMonthlyCodeAliveReports < ActiveRecord::Migration
  def change
    add_column :charge_monthly_code_alive_reports, :sp_name, :string
  end
end
