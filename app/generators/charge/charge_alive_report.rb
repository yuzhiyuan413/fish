ReportGenerator.configure do
  section :charge_alive_2 do
    data_source ChargeDs::ReportUser
    distinct_count "charge_users.uuid"
    join "inner join charge_request_histories on charge_users.uuid = charge_request_histories.uuid"
    condition({"charge_users.activation_time" => params(:date).ago(1.days).all_day})
    condition({"charge_request_histories.request_time" => params(:date).all_day})
    group :tag, :loader_version_short
    sum_group :tag, Distributers::ChargeTagDistributer
    sum_group :loader_version_short, Distributers::LoaderVersionDistributer
  end

  section :charge_alive_3 do
    data_source ChargeDs::ReportUser
    distinct_count "charge_users.uuid"
    join "inner join charge_request_histories on charge_users.uuid = charge_request_histories.uuid"
    condition({"charge_users.activation_time" => params(:date).ago(2.days).all_day})
    condition({"charge_request_histories.request_time" => params(:date).all_day})
    group :tag, :loader_version_short
    sum_group :tag, Distributers::ChargeTagDistributer
    sum_group :loader_version_short, Distributers::LoaderVersionDistributer
  end

  section :charge_alive_7 do
    data_source ChargeDs::ReportUser
    distinct_count "charge_users.uuid"
    join "inner join charge_request_histories on charge_users.uuid = charge_request_histories.uuid"
    condition({"charge_users.activation_time" => params(:date).ago(6.days).all_day})
    condition({"charge_request_histories.request_time" => params(:date).all_day})
    group :tag, :loader_version_short
    sum_group :tag, Distributers::ChargeTagDistributer
    sum_group :loader_version_short, Distributers::LoaderVersionDistributer
  end

  section :charge_alive_15 do
    data_source ChargeDs::ReportUser
    distinct_count "charge_users.uuid"
    join "inner join charge_request_histories on charge_users.uuid = charge_request_histories.uuid"
    condition({"charge_users.activation_time" => params(:date).ago(14.days).all_day})
    condition({"charge_request_histories.request_time" => params(:date).all_day})
    group :tag, :loader_version_short
    sum_group :tag, Distributers::ChargeTagDistributer
    sum_group :loader_version_short, Distributers::LoaderVersionDistributer
  end

  section :charge_alive_30 do
    data_source ChargeDs::ReportUser
    distinct_count "charge_users.uuid"
    join "inner join charge_request_histories on charge_users.uuid = charge_request_histories.uuid"
    condition({"charge_users.activation_time" => params(:date).ago(29.days).all_day})
    condition({"charge_request_histories.request_time" => params(:date).all_day})
    group :tag, :loader_version_short
    sum_group :tag, Distributers::ChargeTagDistributer
    sum_group :loader_version_short, Distributers::LoaderVersionDistributer
  end

  group :charge_alive do
    report :charge_alive_activation do
      report_model Charge::AliveReport
      initialize_fields do
        report_date params(:date)
        tag
        product_version
      end

      field :activation_num  do
        section :charge_activation
        columns :tag, :loader_version_short, :count_distinct_uuid
      end

      after_save do
        extend ChargeHelper
        reset_charge_options_cache(Charge::AliveReport)
      end
    end #report Charge::ActivityMonthReport

    report :charge_alive2 do
      report_model Charge::AliveReport
      initialize_fields do
        report_date params(:date).ago(1.days).to_date
        tag
        product_version
      end

      field :stay_alive2_num  do
        section :charge_alive_2
        columns :tag, :loader_version_short, :count_distinct_charge_users_uuid
      end

    end #report Charge::ActivityMonthReport

    report :charge_alive3 do
      report_model Charge::AliveReport
      initialize_fields do
        report_date params(:date).ago(2.days).to_date
        tag
        product_version
      end

      field :stay_alive3_num  do
        section :charge_alive_3
        columns :tag, :loader_version_short, :count_distinct_charge_users_uuid
      end
    end #report Charge::ActivityMonthReport

    report :charge_alive7 do
      report_model Charge::AliveReport
      initialize_fields do
        report_date params(:date).ago(6.days).to_date
        tag
        product_version
      end

      field :stay_alive7_num do
        section :charge_alive_7
        columns :tag, :loader_version_short, :count_distinct_charge_users_uuid
      end
    end #report Charge::ActivityMonthReport

    report :charge_alive15 do
      report_model Charge::AliveReport
      initialize_fields do
        report_date params(:date).ago(14.days).to_date
        tag
        product_version
      end

      field :stay_alive15_num  do
        section :charge_alive_15
        columns :tag, :loader_version_short, :count_distinct_charge_users_uuid
      end
    end #report Charge::ActivityMonthReport

    report :charge_alive30 do
      report_model Charge::AliveReport
      initialize_fields do
        report_date params(:date).ago(29.days).to_date
        tag
        product_version
      end

      field :stay_alive30_num  do
        section :charge_alive_30
        columns :tag, :loader_version_short, :count_distinct_charge_users_uuid
      end
    end #report Charge::ActivityMonthReport
  end

end #Rg::ReportGenerator.configure
