ReportGenerator.configure do
  section :hourly_seed_activation do
    data_source DailyDs::SeedUser
    count :uid
    condition do
      activation_time params(:date).all_day
    end
    group :activating_tag
    sum_group :activating_tag, Distributers::TagDistributer
  end

  section :hourly_seed_activity do
    data_source DailyDs::SwordRequestHistory
    condition({"sword_request_histories.record_time" => params(:date).all_day })
    join "inner join seed_users on seed_users.uid = sword_request_histories.uid"
    count "sword_request_histories.id"
    distinct_count "sword_request_histories.uid"
    group "seed_users.activating_tag"
    sum_group "seed_users.activating_tag", Distributers::TagDistributer
  end

  section :hourly_seed_v9_activity do
    data_source DailyDs::ReportRequestHistory
    condition do
      request_time params(:date).all_day
      loader_version_short '9.0'
    end
    join "inner join report_users on report_users.uuid = report_request_histories.uuid"
    count "report_request_histories.id"
    distinct_count "report_request_histories.uuid"
    group "report_users.tag"
    sum_group "report_users.tag", Distributers::TagDistributer
  end

  report :hourly_seed_activity do
    report_model Seed::ActivityReport
    initialize_fields do
      report_time params(:date)
      tag
    end

    field :activation_num  do
      section :hourly_seed_activation
      columns :activating_tag, :count_uid
    end

    field :activity_num, :request_num  do
      section :hourly_seed_activity
      columns :activating_tag, :count_distinct_sword_request_histories_uid, :count_sword_request_histories_id
    end

    field :v9_activity_num, :v9_request_num  do
      section :hourly_seed_v9_activity
      columns :tag, :count_distinct_report_request_histories_uuid, :count_report_request_histories_id
    end

    after_save do
      System::TagGroup.reset_tags_options_cache(Seed::ActivityReport,
        System::Constant::PICK_OPTIONS[Seed::ActivityReport])
    end
  end

end
