ReportGenerator.configure do
  section :seed_total_activation do
    data_source BeeDs::SeedUser
    count :uid
    group :activating_tag
    sum_group :activating_tag, Distributers::TagDistributer
  end

  section :seed_total_activation_yesterday do
    data_source BeeDs::SeedUser
    count :uid
    condition do
      activation_time params(:date).yesterday.all_day
    end
    group :activating_tag
    sum_group :activating_tag, Distributers::TagDistributer
  end

  section :seed_total_activity_num_yesterday do
    data_source BeeDs::RequestHistory
    distinct_count "seed_request_histories.uid"
    condition do
      record_time params(:date).yesterday.all_day
    end
    join "inner join seed_users on seed_users.uid = seed_request_histories.uid"
    group "seed_users.activating_tag"
    sum_group "seed_users.activating_tag", Distributers::TagDistributer
  end

  section :seed_total_activity_num_7days do
    data_source BeeDs::RequestHistory
    distinct_count "seed_request_histories.uid"
    condition do
      record_time (params(:date).ago(6.days).beginning_of_day..params(:date).end_of_day)
    end
    join "inner join seed_users on seed_users.uid = seed_request_histories.uid"
    group "seed_users.activating_tag"
    sum_group "seed_users.activating_tag", Distributers::TagDistributer
  end

  section :seed_total_activity_num_30days do
    data_source BeeDs::RequestHistory
    distinct_count "seed_request_histories.uid"
    condition do
      record_time (params(:date).ago(29.days).beginning_of_day..params(:date).end_of_day)
    end
    join "inner join seed_users on seed_users.uid = seed_request_histories.uid"
    group "seed_users.activating_tag"
    sum_group "seed_users.activating_tag", Distributers::TagDistributer
  end

  report :seed_activity_total do
    report_model Seed::ActivityTotalReport
    initialize_fields do
      report_type Seed::ActivityReport.to_s
      tag
    end

    field :total_activation_num do
      section :seed_total_activation
      columns :activating_tag, :count_uid
    end

    field :yesterday_activation_num do
      section :seed_total_activation_yesterday
      columns :activating_tag, :count_uid
    end

    field :yesterday_activity_num do
      section :seed_total_activity_num_yesterday
      columns :activating_tag, :count_distinct_seed_request_histories_uid
    end

    field :activity7 do
      section :seed_total_activity_num_7days
      columns :activating_tag, :count_distinct_seed_request_histories_uid
    end

    field :activity30 do
      section :seed_total_activity_num_30days
      columns :activating_tag, :count_distinct_seed_request_histories_uid
    end

    clear_table do
      updated_at params(:date).yesterday.all_day
    end

  end

end
