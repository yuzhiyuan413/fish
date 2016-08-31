ReportGenerator.configure do
  section :charge_activation_total do
    data_source ChargeDs::ReportUser
    count :uuid
    group :tag, :loader_version_short
    sum_group :tag, Distributers::ChargeTagDistributer
    sum_group :loader_version_short, Distributers::LoaderVersionDistributer
  end

  section :charge_activation_yesterday do
    data_source Charge::ActivationReport
    select :tag, :product_version, :activation_num
    condition do
      report_date params(:date).yesterday
    end
  end

  section :charge_activity_yesterday do
    data_source Charge::ActivityReport
    select :tag, :product_version, :activity_num
    condition do
      province "全部省份"
      report_date params(:date).yesterday
    end
  end

  section :charge_activity_7 do
    data_source ChargeDs::ReportRequestHistory
    distinct_count :uuid
    condition do
      request_time (params(:date).ago(6.days).beginning_of_day..params(:date).end_of_day)
    end
    group :tag, :loader_version_short
    sum_group :tag, Distributers::ChargeTagDistributer
    sum_group :loader_version_short, Distributers::LoaderVersionDistributer
  end

  section :charge_activity_30 do
    data_source ChargeDs::ReportRequestHistory
    distinct_count :uuid
    condition do
      request_time (params(:date).ago(29.days).beginning_of_day..params(:date).end_of_day)
    end
    group :tag, :loader_version_short
    sum_group :tag, Distributers::ChargeTagDistributer
    sum_group :loader_version_short, Distributers::LoaderVersionDistributer
  end

  report :charge_total do
    report_model Charge::TotalReport
    initialize_fields do
      tag
      product_version
    end

    field :total_activation_num do
        section :charge_activation_total
        columns :tag, :loader_version_short, :count_uuid
    end

    field :yesterday_activation_num do
        section :charge_activation_yesterday
        columns :tag, :product_version, :activation_num
    end

    field :yesterday_activity_num do
        section :charge_activity_yesterday
        columns :tag, :product_version, :activity_num
    end

    field :activity7 do
        section :charge_activity_7
        columns :tag, :loader_version_short, :count_distinct_uuid
    end

    field :activity30 do
        section :charge_activity_30
        columns :tag, :loader_version_short, :count_distinct_uuid
    end

    clear_table do
      updated_at 2.days.ago.all_day
    end
  end # report :charge_total do
end
