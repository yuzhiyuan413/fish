ReportGenerator.configure do
  section :seed_activation do
    data_source BeeDs::SeedUser
    count :uid
    condition do
      activation_time params(:date).all_day
    end
    group :activating_tag
    sum_group :activating_tag, Distributers::TagDistributer
  end

  section :seed_activity do
    data_source BeeDs::RequestHistory
    condition({"seed_request_histories.record_time" => params(:date).all_day })
    join "inner join seed_users on seed_users.uid = seed_request_histories.uid"
    count "seed_request_histories.id"
    distinct_count "seed_request_histories.uid"
    group "seed_users.activating_tag"
    sum_group "seed_users.activating_tag", Distributers::TagDistributer
  end

  section :seed_v9_activity do
    data_source ChargeDs::ReportRequestHistory
    condition do
      request_time params(:date).all_day
      loader_version_short '9.0'
    end
    join "inner join charge_users on charge_users.uuid = charge_request_histories.uuid"
    count "charge_request_histories.id"
    distinct_count "charge_request_histories.uuid"
    group "charge_users.tag"
    sum_group "charge_users.tag", Distributers::TagDistributer
  end

  report :seed_activity do
    report_model Seed::ActivityReport
    initialize_fields do
      report_time params(:date)
      tag
    end

    field :activation_num  do
      section :seed_activation
      columns :activating_tag, :count_uid
    end

    field :activity_num, :request_num  do
      section :seed_activity
      columns :activating_tag, :count_distinct_seed_request_histories_uid, :count_seed_request_histories_id
    end

    field :v9_activity_num, :v9_request_num  do
      section :seed_v9_activity
      columns :tag, :count_distinct_charge_request_histories_uuid, :count_charge_request_histories_id
    end

    after_save do
      System::TagGroup.reset_tags_options_cache(Seed::ActivityReport,
        System::Constant::PICK_OPTIONS[Seed::ActivityReport])
    end
  end

end
