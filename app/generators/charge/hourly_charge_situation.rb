ReportGenerator.configure do
  section :charge_situation_activation_today do
    data_source Charge::ActivationReport
    select :tag, :product_version ,:activation_num
    condition do
      report_date params(:date)
    end
  end

  section :charge_situation_activation_yesterday do
    data_source Charge::ActivationReport
    select :tag, :product_version ,:activation_num
    condition do
      report_date params(:date).yesterday
    end
  end

  section :charge_situation_activity_today do
    data_source Charge::ActivityReport
    select :tag, :product_version, :activity_num, :request_times, :request_per_avg
    condition do
      province "全部省份"
      report_date params(:date)
    end
  end

  section :charge_situation_activity_yesterday do
    data_source Charge::ActivityReport
    select :tag, :product_version, :activity_num, :request_times, :request_per_avg
    condition do
      province "全部省份"
      report_date params(:date).yesterday
    end
  end

  section :charge_situation_activation_yesterday_at_this_time do
    data_source DailyDs::ReportUser
    distinct_count :uuid
    condition do
      activation_time 1.day.ago.to_time.beginning_of_day..Time.now.at_beginning_of_hour.ago(1.day)
    end
    group :tag, :loader_version_short
    sum_group :tag, Distributers::ChargeTagDistributer
    sum_group :loader_version_short, Distributers::LoaderVersionDistributer
  end

  section :charge_situation_activity_yesterday_at_this_time do
    data_source DailyDs::ReportRequestHistory
    count :id
    distinct_count :uuid
    condition do
      request_time 1.day.ago.to_time.beginning_of_day..Time.now.at_beginning_of_hour.ago(1.day)
    end
    group :tag, :loader_version_short
    sum_group :tag, Distributers::ChargeTagDistributer
    sum_group :loader_version_short, Distributers::LoaderVersionDistributer
  end

  group :hourly_charge_situation do
    report :today_situation do
      report_model Charge::SituationReport
      initialize_fields do
        record_time "今日"
        tag
        product_version
      end

      field :activation_num  do
        section :charge_situation_activation_today
        columns :tag, :product_version, :activation_num
      end

      field :activity_num, :request_times, :avg_request_times  do
        section :charge_situation_activity_today
        columns :tag, :product_version, :activity_num, :request_times, :request_per_avg
      end

      clear_table do
        updated_at 2.days.ago.all_day
      end
    end

    report :yesterday_situation do
      report_model Charge::SituationReport
      initialize_fields do
        record_time "昨日全天"
        tag
        product_version
      end

      field :activation_num  do
        section :charge_situation_activation_yesterday
        columns :tag, :product_version, :activation_num
      end

      field :activity_num, :request_times, :avg_request_times  do
        section :charge_situation_activity_yesterday
        columns :tag, :product_version, :activity_num, :request_times, :request_per_avg
      end
    end

    report :yesterday_at_this_time_situation do
      report_model Charge::SituationReport
      initialize_fields do
        record_time "昨日此时"
        tag
        product_version
      end

      field :activation_num  do
        section :charge_situation_activation_yesterday_at_this_time
        columns :tag, :loader_version_short, :count_distinct_uuid
      end

      field :activity_num, :request_times  do
        section :charge_situation_activity_yesterday_at_this_time
        columns :tag, :loader_version_short, :count_distinct_uuid, :count_id
      end

      field :avg_request_times do
        expr "? / ?", :request_times, :activity_num
      end

      after_save do
        extend ChargeHelper
        reset_charge_options_cache(Charge::SituationReport)
      end

    end
  end

end #Rg::ReportGenerator.configure
