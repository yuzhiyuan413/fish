ReportGenerator.configure do
  section :charge_zhongtian_monthly_code_downlink_successful do
    data_source SmartDs::ZhongTianMonthlyData
    distinct_count :mobile
    condition do
      pay_date params(:date).all_day
      status 1
    end
    group :service_id, :service_type
  end

  # section :charge_zhongtian_monthly_code_downlink_failed do
  #   data_source SmartDs::ZhongTianMonthlyData
  #   distinct_count :mobile
  #   condition do
  #     pay_date params(:date).all_day
  #     status 0
  #   end
  #   group :service_id, :service_type
  # end

  report :charge_zhongtian_monthly_code_downlink_report do
    report_model Charge::MonthlyCodeDownlinkReport

    initialize_fields do
      report_date params(:date)
      service_id
      service_type
    end

    field :successful_users_num  do
      section :charge_zhongtian_monthly_code_downlink_successful
      columns :service_id, :service_type, :count_distinct_mobile
    end

    # field :failed_users_num  do
    #   section :charge_zhongtian_monthly_code_downlink_failed
    #   columns :service_id, :service_type, :count_distinct_mobile
    # end

  end  # report
end # Rg::ReportGenerator.configure
