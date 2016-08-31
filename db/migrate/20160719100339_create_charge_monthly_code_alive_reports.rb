class CreateChargeMonthlyCodeAliveReports < ActiveRecord::Migration
  def change
    create_table :charge_monthly_code_alive_reports do |t|
      t.date :report_date
      t.integer :sp_id
      t.string :code
      t.string :dest_number
      t.integer :theory_alive, default: 0 # 理论留存用户数
      t.integer :order_alive, default: 0 # 账单留存用户数
      t.integer :deducted_alive, default: 0 # 留存总扣量
      t.integer :last_month_deducted_alive, default: 0 # 上月留存扣量
      t.integer :order_charged_alive, default: 0 # 账单留存付费
      t.integer :activation, default: 0 # 同步新增订购
      t.integer :order_activation, default: 0 # 账单新增订购
      t.integer :deducted_activation, default: 0 # 新增扣量
      t.integer :order_activation_charged, default: 0 # 账单新增付费
      t.integer :lt_72, default: 0 # <72退订
      t.integer :gt_72, default: 0 # >72退订
      t.integer :unsubscribed_alive, default: 0 # 留存退订
      t.integer :rate, default: 0 # 转化率

      t.timestamps null: false
    end
  end
end
