ReportGenerator.configure do
  section :hourly_charge_activation do
    data_source DailyDs::ReportUser
    distinct_count :uuid
    condition do
      activation_time params(:date).all_day
    end
    group :tag, :loader_version_short
    sum_group :tag, Distributers::ChargeTagDistributer
    sum_group :loader_version_short, Distributers::LoaderVersionDistributer
  end

  report :hourly_charge_activation do
    report_model Charge::ActivationReport
    initialize_fields do
      report_date params(:date)
      tag
      product_version
    end

    field :activation_num  do
      section :hourly_charge_activation
      columns :tag, :loader_version_short, :count_distinct_uuid
    end

    after_save do
      extend ChargeHelper
      reset_charge_options_cache(Charge::ActivationReport)
    end
  end # report Charge::ActivationReport
end #Rg::ReportGenerator.configure
