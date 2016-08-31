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

  section :seed_panda_activation do
    mixin :seed_activation, except: [:condition, :count]
    distinct_count "seed_users.uid"
    condition({"seed_users.activation_time" => params(:date).all_day})
    condition({"users.activation_time" => params(:date).all_day})
    join "inner join users on seed_users.uid = users.current_uuid"
  end

  section :seed_old_user_active do
    data_source PandaDs::User
    condition({"seed_users.activation_time" => params(:date).all_day})
    condition ["users.activation_time < ?", params(:date).ago(1.day)]
    distinct_count "seed_users.uid"
    join "inner join seed_users on users.current_uuid = seed_users.uid"
    group "seed_users.activating_tag"
    sum_group "seed_users.activating_tag", Distributers::TagDistributer
  end

  section :seed_old_user_activity do
    mixin :seed_activation, except: [:condition, :join, :count]
    distinct_count "seed_users.uid"
    condition({"seed_users.activation_time" => params(:date).all_day})
    condition [ "smart_v9_production.request_histories.server_time between ? and ? ",
          params(:date).ago(2.months), params(:date).ago(1.day)]
    join "inner join smart_v9_production.request_histories on seed_users.uid = smart_v9_production.request_histories.current_uuid"
  end

  section :seed_bash_activation do
    mixin :seed_old_user_activity, except: :condition
    condition({"seed_users.activation_time" => params(:date).all_day})
    condition ["smart_v9_production.request_histories.tag != 'distillery' and smart_v9_production.request_histories.server_time > ? " , params(:date).beginning_of_day]
  end

  report :seed_activation do
    report_model Seed::ActivationReport

    initialize_fields do
      report_time params(:date)
      tag
    end

    field :seed_activation_num  do
      section :seed_activation
      columns :activating_tag, :count_uid
    end

    field :panda_activation_num  do
      section :seed_panda_activation
      columns :activating_tag, :count_distinct_seed_users_uid
    end

    field :old_user_active_num  do
      section :seed_old_user_active
      columns :activating_tag, :count_distinct_seed_users_uid
    end

    field :old_user_activity_num  do
      section :seed_old_user_activity
      columns :activating_tag, :count_distinct_seed_users_uid
    end

    field :bash_activation_num  do
      section :seed_bash_activation
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
