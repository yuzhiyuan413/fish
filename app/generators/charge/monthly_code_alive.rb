ReportGenerator.configure do
  # 新增订购
  section :monthly_code_activation do
    data_source CrabDs::MonthlyCodeChargeHistory
    distinct_count :uuid
    condition do
      time params(:date).all_month
      action_id Charge::MonthlyCodeAliveReport::SUBSCRIBE
    end
    group :sp_id, :code, :dest_number
  end

  # 上个月的留存用户数
  section :monthly_code_last_month_alive do
    data_source Charge::MonthlyCodeAliveReport
    select :order_alive, :order_activation, :lt_72, :gt_72, :unsubscribed_alive
    condition do
      report_date params(:date).ago(1.month).beginning_of_month
    end
    group :sp_id, :code, :dest_number
  end

  # TODO 查询留存退订用户数
  section :monthly_code_unsubscribed_alive do
  end

  # TODO 查询72小时内退订用户数
  # TODO 查询72小时外退订用户数

  report :monthly_code_alive_report do
    report_model Charge::MonthlyCodeAliveReport
    initialize_fields do
      report_date params(:date).beginning_of_month
      sp_id
      code
      dest_number
    end

    field :activation  do
      section :monthly_code_activation
      columns :sp_id, :code, :dest_number, :count_distinct_uuid
    end

    field :unsubscribed_alive do
      # TODO
    end

    field :lt_72 do
      # TODO
    end

    field :gt_72 do
      # TODO
    end

    field :theory_alive do
      section :monthly_code_last_month_alive
      # TODO
      # order_alive + order_activation - lt_72 - gt_72 - unsubscribed_alive
    end

    before_save do |records|
      p records.keys
      p records.values
      records
    end

  end # report Charge::MonthlyCodeAliveReport

end