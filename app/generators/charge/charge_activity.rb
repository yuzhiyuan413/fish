ReportGenerator.configure do
  section :charge_activity do
    data_source ChargeDs::ReportRequestHistory
    count :id
    distinct_count :uuid
    condition do
      request_time params(:date).all_day
    end
    group :tag, :loader_version_short, :province_id
    sum_group :tag, Distributers::ChargeTagDistributer
    sum_group :loader_version_short, Distributers::LoaderVersionDistributer
    sum_group :province_id, Distributers::ProvinceDistributer
  end

  section :charge_activity_cmcc do
    data_source ChargeDs::ReportRequestHistory
    distinct_count :uuid
    condition do
      request_time params(:date).all_day
      operator_id 1
    end
    group :tag, :loader_version_short, :province_id
    sum_group :tag, Distributers::ChargeTagDistributer
    sum_group :loader_version_short, Distributers::LoaderVersionDistributer
    sum_group :province_id, Distributers::ProvinceDistributer
  end

  section :charge_activity_cucc do
    data_source ChargeDs::ReportRequestHistory
    distinct_count :uuid
    condition do
      request_time params(:date).all_day
      operator_id 2
    end
    group :tag, :loader_version_short, :province_id
    sum_group :tag, Distributers::ChargeTagDistributer
    sum_group :loader_version_short, Distributers::LoaderVersionDistributer
    sum_group :province_id, Distributers::ProvinceDistributer
  end

  section :charge_activity_ctcc do
    data_source ChargeDs::ReportRequestHistory
    distinct_count :uuid
    condition do
      request_time params(:date).all_day
      operator_id 3
    end
    group :tag, :loader_version_short,:province_id
    sum_group :tag, Distributers::ChargeTagDistributer
    sum_group :loader_version_short, Distributers::LoaderVersionDistributer
    sum_group :province_id, Distributers::ProvinceDistributer
  end

  section :charge_activity_others_sp do
    data_source ChargeDs::ReportRequestHistory
    distinct_count :uuid
    condition do
      request_time params(:date).all_day
      operator_id [0,4]
    end
    group :tag, :loader_version_short, :province_id
    sum_group :tag, Distributers::ChargeTagDistributer
    sum_group :loader_version_short, Distributers::LoaderVersionDistributer
    sum_group :province_id, Distributers::ProvinceDistributer
  end

  report :charge_activity do
    report_model Charge::ActivityReport

    initialize_fields do
      report_date params(:date)
      tag
      product_version
      province
    end

    field :activity_num, :request_times  do
      section :charge_activity
      columns :tag, :loader_version_short, :province_id, :count_distinct_uuid, :count_id
    end

    field :cmcc_num  do
      section :charge_activity_cmcc
      columns :tag, :loader_version_short, :province_id, :count_distinct_uuid
    end

    field :cucc_num  do
      section :charge_activity_cucc
      columns :tag, :loader_version_short, :province_id, :count_distinct_uuid
    end

    field :ctcc_num do
      section :charge_activity_ctcc
      columns :tag, :loader_version_short, :province_id, :count_distinct_uuid
    end

    field :others_sp_num  do
      section :charge_activity_others_sp
      columns :tag, :loader_version_short, :province_id, :count_distinct_uuid
    end

    field :request_per_avg do
      expr "? / ?", :request_times, :activity_num
    end

    before_save do |records|
      extend ProvinceHelper
      records_province_id_to_name(records)
    end

    after_save do
      extend ChargeHelper
      reset_charge_options_cache(Charge::ActivityReport)
    end
  end  #report Charge::ActivityReport
end #Rg::ReportGenerator.configure
