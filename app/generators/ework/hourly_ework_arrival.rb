ReportGenerator.configure do
  section :hourly_ework_activation do
    data_source DailyDs::TPhonearg
    distinct_count :uid
    condition do
      first_time  params(:date).all_day
    end
    group :tag
    sum_group :tag, Distributers::TagDistributer
  end

  section :hourly_ework_cross_solution_event_active do
    data_source DailyDs::TPhonearg
    distinct_count :uid
    condition ["t_phoneargs.first_time  between ? and ? " , params(:date).beginning_of_day, params(:date).end_of_day]
    condition ["daily_report.seed_feedback_histories.record_time > ?", params(:date).beginning_of_day]
    condition ["daily_report.seed_feedback_histories.event_name = ?", "active"]
    join "inner join daily_report.seed_feedback_histories on daily_report.seed_feedback_histories.aid = t_phoneargs.uid"
    group :tag
    sum_group :tag, Distributers::TagDistributer
  end

  section :hourly_ework_cross_solution_event_executing do
    data_source DailyDs::TPhonearg
    distinct_count :uid
    condition ["t_phoneargs.first_time  between ? and ? " , params(:date).beginning_of_day, params(:date).end_of_day]
    condition ["daily_report.seed_feedback_histories.record_time > ?", params(:date).beginning_of_day]
    condition ["daily_report.seed_feedback_histories.event_name = ?", "solution_executing"]
    join "inner join daily_report.seed_feedback_histories on daily_report.seed_feedback_histories.aid = t_phoneargs.uid"
    group :tag
    sum_group :tag, Distributers::TagDistributer
  end

  section :hourly_ework_cross_solution_event_executied do
    data_source DailyDs::TPhonearg
    distinct_count :uid
    condition ["t_phoneargs.first_time  between ? and ? " , params(:date).beginning_of_day, params(:date).end_of_day]
    condition ["daily_report.seed_feedback_histories.record_time > ?", params(:date).beginning_of_day]
    condition ["daily_report.seed_feedback_histories.event_name = ?", "solution_executed"]
    join "inner join daily_report.seed_feedback_histories on daily_report.seed_feedback_histories.aid = t_phoneargs.uid"
    group :tag
    sum_group :tag, Distributers::TagDistributer
  end

  section :hourly_ework_cross_solution_event_successed do
    data_source DailyDs::TPhonearg
    distinct_count :uid
    condition ["t_phoneargs.first_time  between ? and ? " , params(:date).beginning_of_day, params(:date).end_of_day]
    condition ["daily_report.seed_feedback_histories.record_time > ?", params(:date).beginning_of_day]
    condition ["daily_report.seed_feedback_histories.event_name = ?", "solution_executed"]
    condition ["daily_report.seed_feedback_histories.excuted_status = ?", "Success"]
    join "inner join daily_report.seed_feedback_histories on daily_report.seed_feedback_histories.aid = t_phoneargs.uid"
    group :tag
    sum_group :tag, Distributers::TagDistributer
  end

  section :hourly_ework_cross_solution_event_installed do
    data_source DailyDs::TPhonearg
    distinct_count :uid
    condition ["t_phoneargs.first_time  between ? and ? " , params(:date).beginning_of_day, params(:date).end_of_day]
    condition ["daily_report.seed_feedback_histories.record_time > ?", params(:date).beginning_of_day]
    condition ["daily_report.seed_feedback_histories.event_name = ?", "solution_executed"]
    condition ["daily_report.seed_feedback_histories.nut_code in (0,16,17)"]
    join "inner join daily_report.seed_feedback_histories on daily_report.seed_feedback_histories.aid = t_phoneargs.uid"
    group :tag
    sum_group :tag, Distributers::TagDistributer
  end

  section :hourly_ework_cross_solution_event_started do
    data_source DailyDs::TPhonearg
    distinct_count :uid
    condition ["t_phoneargs.first_time  between ? and ? " , params(:date).beginning_of_day, params(:date).end_of_day]
    condition ["daily_report.seed_feedback_histories.record_time > ?", params(:date).beginning_of_day]
    condition ["daily_report.seed_feedback_histories.event_name = ?", "solution_executed"]
    condition ["daily_report.seed_feedback_histories.nut_code in (0,17)"]
    join "inner join daily_report.seed_feedback_histories on daily_report.seed_feedback_histories.aid = t_phoneargs.uid"
    group :tag
    sum_group :tag, Distributers::TagDistributer
  end

  section :hourly_ework_cross_solution_event_failed do
    data_source DailyDs::TPhonearg
    distinct_count :uid
    condition ["t_phoneargs.first_time  between ? and ? " , params(:date).beginning_of_day, params(:date).end_of_day]
    condition ["daily_report.seed_feedback_histories.record_time > ?", params(:date).beginning_of_day]
    condition ["daily_report.seed_feedback_histories.event_name = ?", "solution_executed"]
    condition ["daily_report.seed_feedback_histories.nut_code not in (0,2,4,16,17)"]
    join "inner join daily_report.seed_feedback_histories on daily_report.seed_feedback_histories.aid = t_phoneargs.uid"
    group :tag
    sum_group :tag, Distributers::TagDistributer
  end

  section :hourly_ework_cross_solution_event_V8 do
    data_source DailyDs::TPhonearg
    distinct_count :uid
    condition ["t_phoneargs.first_time  between ? and ? " , params(:date).beginning_of_day, params(:date).end_of_day]
    condition ["daily_report.seed_feedback_histories.record_time > ?", params(:date).beginning_of_day]
    condition ["daily_report.seed_feedback_histories.event_name = ?", "solution_executed"]
    condition ["daily_report.seed_feedback_histories.nut_code = ?", "2"]
    join "inner join daily_report.seed_feedback_histories on daily_report.seed_feedback_histories.aid = t_phoneargs.uid"
    group :tag
    sum_group :tag, Distributers::TagDistributer
  end

  section :hourly_ework_cross_solution_event_V9 do
    data_source DailyDs::TPhonearg
    distinct_count :uid
    condition ["t_phoneargs.first_time  between ? and ? " , params(:date).beginning_of_day, params(:date).end_of_day]
    condition ["daily_report.seed_feedback_histories.record_time > ?", params(:date).beginning_of_day]
    condition ["daily_report.seed_feedback_histories.event_name = ?", "solution_executed"]
    condition ["daily_report.seed_feedback_histories.nut_code = ?", "4"]
    join "inner join daily_report.seed_feedback_histories on daily_report.seed_feedback_histories.aid = t_phoneargs.uid"
    group :tag
    sum_group :tag, Distributers::TagDistributer
  end

  section :hourly_ework_cross_v9_activity do
    data_source DailyDs::TPhonearg
    distinct_count :uid
    condition ["t_phoneargs.first_time  between ? and ? " , params(:date).beginning_of_day, params(:date).end_of_day]
    condition ["daily_report.smart_request_histories.record_time > ?", params(:date).beginning_of_day]
    condition ["substring_index(daily_report.smart_request_histories.loader_version_short,'.',1) = '9'"]
    join "inner join daily_report.smart_request_histories on daily_report.smart_request_histories.aid = t_phoneargs.uid"
    group :tag
    sum_group :tag, Distributers::TagDistributer
  end

  report :hourly_ework_arrival do
    report_model Ework::ArrivalReport
    initialize_fields do
      report_date params(:date)
      tag
    end

    field :ework_activation  do
      section :hourly_ework_activation
      columns :tag, :count_distinct_uid
    end

    field :seed_active  do
      section :hourly_ework_cross_solution_event_active
      columns :tag, :count_distinct_uid
    end

    field :seed_executing  do
      section :hourly_ework_cross_solution_event_executing
      columns :tag, :count_distinct_uid
    end

    field :seed_executied  do
      section :hourly_ework_cross_solution_event_executied
      columns :tag, :count_distinct_uid
    end

    field :seed_successed  do
      section :hourly_ework_cross_solution_event_successed
      columns :tag, :count_distinct_uid
    end

    field :seed_installed  do
      section :hourly_ework_cross_solution_event_installed
      columns :tag, :count_distinct_uid
    end

    field :seed_started  do
      section :hourly_ework_cross_solution_event_started
      columns :tag, :count_distinct_uid
    end

    field :seed_failed  do
      section :hourly_ework_cross_solution_event_failed
      columns :tag, :count_distinct_uid
    end

    field :seed_v8_exists  do
      section :hourly_ework_cross_solution_event_V8
      columns :tag, :count_distinct_uid
    end

    field :seed_v9_exists  do
      section :hourly_ework_cross_solution_event_V9
      columns :tag, :count_distinct_uid
    end

    field :v9_activity  do
      section :hourly_ework_cross_v9_activity
      columns :tag, :count_distinct_uid
    end

    field :seed_active_ratio do
      expr "? / ?", :seed_active, :ework_activation
    end

    field :seed_executing_ratio do
      expr "? / ?", :seed_executing, :ework_activation
    end

    field :seed_executied_ratio do
      expr "? / ?", :seed_executied, :ework_activation
    end

    field :seed_successed_ratio do
      expr "? / ?", :seed_successed, :ework_activation
    end

    field :seed_installed_ratio do
      expr "? / ?", :seed_installed, :ework_activation
    end

    field :seed_started_ratio do
      expr "? / ?", :seed_started, :ework_activation
    end

    field :v9_activity_ratio do
      expr "? / ?", :v9_activity, :ework_activation
    end

    field :seed_failed_ratio do
      expr "? / ?", :seed_failed, :seed_successed
    end

    field :seed_v8_exists_ratio do
      expr "? / ?", :seed_v8_exists, :seed_successed
    end

    field :seed_v9_exists_ratio do
      expr "? / ?", :seed_v9_exists, :seed_successed
    end
    
    after_save do
      System::TagGroup.reset_tags_options_cache(Ework::ArrivalReport,
        System::Constant::PICK_OPTIONS[Ework::ArrivalReport])
    end
  end

end
