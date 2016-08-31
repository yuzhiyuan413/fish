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

    section :seed_alive2 do
      data_source BeeDs::RequestHistory
      condition do
        record_time params(:date).all_day
      end
      condition({"seed_users.activation_time" => params(:date).ago(1.days).all_day })
      distinct_count "seed_users.uid"
      join "inner join seed_users on seed_users.uid = seed_request_histories.uid"
      group "seed_users.activating_tag"
      sum_group "seed_users.activating_tag", Distributers::TagDistributer
    end

    section :seed_alive3 do
      data_source BeeDs::RequestHistory
      condition do
        record_time params(:date).all_day
      end
      condition({"seed_users.activation_time" => params(:date).ago(2.days).all_day })
      distinct_count "seed_users.uid"
      join "inner join seed_users on seed_users.uid = seed_request_histories.uid"
      group "seed_users.activating_tag"
      sum_group "seed_users.activating_tag", Distributers::TagDistributer
    end

    section :seed_alive7 do
      data_source BeeDs::RequestHistory
      condition do
        record_time params(:date).all_day
      end
      condition({"seed_users.activation_time" => params(:date).ago(6.days).all_day })
      distinct_count "seed_users.uid"
      join "inner join seed_users on seed_users.uid = seed_request_histories.uid"
      group "seed_users.activating_tag"
      sum_group "seed_users.activating_tag", Distributers::TagDistributer
    end

    section :seed_alive15 do
      data_source BeeDs::RequestHistory
      condition do
        record_time params(:date).all_day
      end
      condition({"seed_users.activation_time" => params(:date).ago(14.days).all_day })
      distinct_count "seed_users.uid"
      join "inner join seed_users on seed_users.uid = seed_request_histories.uid"
      group "seed_users.activating_tag"
      sum_group "seed_users.activating_tag", Distributers::TagDistributer
    end

    section :seed_alive30 do
      data_source BeeDs::RequestHistory
      condition do
        record_time params(:date).all_day
      end
      condition({"seed_users.activation_time" => params(:date).ago(29.days).all_day })
      distinct_count "seed_users.uid"
      join "inner join seed_users on seed_users.uid = seed_request_histories.uid"
      group "seed_users.activating_tag"
      sum_group "seed_users.activating_tag", Distributers::TagDistributer
    end

    group :seed_alive do
      report :seed_alive_activation do
        report_model Seed::AliveReport
        initialize_fields do
          report_time params(:date)
          tag
        end

        field :activation_num  do
          section :seed_activation
          columns :activating_tag, :count_uid
        end
      end

      report :seed_alive2 do
        report_model Seed::AliveReport
        initialize_fields do
          report_time params(:date).ago(1.days)
          tag
        end

        field :stay_alive2 do
          section :seed_alive2
          columns :activating_tag, :count_distinct_seed_users_uid
        end

      end

      report :seed_alive3 do
        report_model Seed::AliveReport
        initialize_fields do
          report_time params(:date).ago(2.days)
          tag
        end

        field :stay_alive3 do
          section :seed_alive3
          columns :activating_tag, :count_distinct_seed_users_uid
        end
      end

      report :seed_alive7 do
        report_model Seed::AliveReport
        initialize_fields do
          report_time params(:date).ago(6.days)
          tag
        end

        field :stay_alive7 do
          section :seed_alive7
          columns :activating_tag, :count_distinct_seed_users_uid
        end
      end

      report :seed_alive15 do
        report_model Seed::AliveReport
        initialize_fields do
          report_time params(:date).ago(14.days)
          tag
        end

        field :stay_alive15 do
          section :seed_alive15
          columns :activating_tag, :count_distinct_seed_users_uid
        end
      end

      report :seed_alive30 do
        report_model Seed::AliveReport
        initialize_fields do
          report_time params(:date).ago(29.days)
          tag
        end

        field :stay_alive30 do
          section :seed_alive30
          columns :activating_tag, :count_distinct_seed_users_uid
        end

        after_save do
          System::TagGroup.reset_tags_options_cache(Seed::AliveReport,
            System::Constant::PICK_OPTIONS[Seed::AliveReport])
        end
      end

    end

end
