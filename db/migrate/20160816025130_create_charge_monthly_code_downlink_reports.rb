class CreateChargeMonthlyCodeDownlinkReports < ActiveRecord::Migration
  def change
    create_table :charge_monthly_code_downlink_reports do |t|
      t.date :report_date
      t.string :report_type
      t.string :code_name
      t.integer :deliver_users_num,             default: 0
      t.integer :theory_successful_users_num,   default: 0
      t.integer :activation_users_num,          default: 0
      t.integer :lt_72_unsubscribed_users_num,  defalt: 0
      t.integer :gt_72_unsubscribed_users_num,  defalt: 0
      t.integer :no_downlink_users_num,         default: 0
      t.integer :low_downlink_users_num,        default: 0
      t.integer :successful_users_num,          default: 0

      t.timestamps null: false
    end
  end
end
