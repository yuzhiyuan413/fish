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

  section :hourly_seed_panda_activation do
    mixin :hourly_seed_activation, except: [:condition, :count]
    distinct_count "seed_users.uid"
    condition({"seed_users.activation_time" => params(:date).all_day})
    condition({"panda_users.activation_time" => params(:date).all_day})
    join "inner join panda_users on seed_users.uid = panda_users.current_uuid"
  end

  section :hourly_seed_old_user_active do
    data_source DailyDs::PandaUser
    condition({"seed_users.activation_time" => params(:date).all_day})
    condition ["panda_users.activation_time < ?", params(:date).ago(1.day)]
    distinct_count "seed_users.uid"
    join "inner join seed_users on panda_users.current_uuid = seed_users.uid"
    group "seed_users.activating_tag"
    sum_group "seed_users.activating_tag", Distributers::TagDistributer
  end

  section :hourly_seed_old_user_activity do
    mixin :hourly_seed_activation, except: [:condition, :join, :count]
    distinct_count "seed_users.uid"
    condition({"seed_users.activation_time" => params(:date).all_day})
    condition [ "daily_report.smart_request_histories.record_time between ? and ? ",
          params(:date).ago(2.months), params(:date).ago(1.day)]
    join "inner join daily_report.smart_request_histories on seed_users.uid = daily_report.smart_request_histories.current_uuid"
  end

  section :hourly_seed_bash_activation do
    mixin :hourly_seed_old_user_activity, except: :condition
    condition({"seed_users.activation_time" => params(:date).all_day})
    condition ["daily_report.smart_request_histories.tag != 'distillery' and daily_report.smart_request_histories.record_time > ? " , params(:date).beginning_of_day]
  end

  report :hourly_seed_activation do
    report_model Seed::ActivationReport

    initialize_fields do
      report_time params(:date)
      tag
    end

    field :seed_activation_num  do
      section :hourly_seed_activation
      columns :activating_tag, :count_uid
    end

    field :panda_activation_num  do
      section :hourly_seed_panda_activation
      columns :activating_tag, :count_distinct_seed_users_uid
    end

    field :old_user_active_num  do
      section :hourly_seed_old_user_active
      columns :activating_tag, :count_distinct_seed_users_uid
    end

    field :old_user_activity_num  do
      section :hourly_seed_old_user_activity
      columns :activating_tag, :count_distinct_seed_users_uid
    end

    field :bash_activation_num  do
      section :hourly_seed_bash_activation
      columns :activating_tag, :count_distinct_seed_users_uid
    end

    field :bash_activation_ratio do
      expr "? / ?", :bash_activation_num, :seed_activation_num
    end

    before_save do |records|
      extend GeneratorHelper
      fill_partners(records)
    end

    after_save do
      System::TagGroup.reset_tags_options_cache(Seed::ActivationReport,
        System::Constant::PICK_OPTIONS[Seed::ActivationReport])
    end

  end
end
