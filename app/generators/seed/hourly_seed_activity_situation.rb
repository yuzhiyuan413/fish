ReportGenerator.configure do
    section :hourly_today_seed_activity_situation do
      data_source Seed::ActivityReport
      select :tag, :activity_num, :activation_num, :request_num
      condition do
        report_time params(:date).all_day
      end
    end

    section :hourly_yesterday_seed_activity_situation do
      data_source Seed::ActivityReport
      select :tag, :activity_num, :activation_num, :request_num
      condition do
        report_time params(:date).ago(1.day).all_day
      end
    end

    section :hourly_yesterday_at_time_seed_activity_situation do
      data_source DailyDs::SwordRequestHistory
      count "sword_request_histories.id"
      distinct_count "sword_request_histories.uid"
      condition do
        record_time 1.day.ago.to_time.beginning_of_day..Time.now.at_beginning_of_hour.ago(1.day)
      end
      join "inner join seed_users on seed_users.uid = sword_request_histories.uid"
      group :tag
      sum_group :tag, Distributers::TagDistributer
    end

    section :hourly_seed_activation_situation do
      data_source DailyDs::SeedUser
      count :uid
      condition do
        activation_time 1.day.ago.to_time.beginning_of_day..Time.now.at_beginning_of_hour.ago(1.day)
      end
      group :activating_tag
      sum_group :activating_tag, Distributers::TagDistributer
    end

    group :hourly_seed_activity_situation_group do
      #用户概况
      report :hourly_seed_activity_situation_today do
        report_model Seed::ActivitySituationReport
        initialize_fields do
          record_time '今日'
          report_type Seed::ActivityReport.to_s
          tag
        end

        field :activity_num, :activation_num, :request_times do
          section :hourly_today_seed_activity_situation
          columns :tag, :activity_num, :activation_num, :request_num
        end

        field :avg_request_times do
          expr "? / ?", :request_times, :activity_num
        end

      end

      report :hourly_seed_activity_situation_yesterday do
        report_model Seed::ActivitySituationReport
        initialize_fields do
          record_time '昨日全天'
          report_type Seed::ActivityReport.to_s
          tag
        end

        field :activity_num, :activation_num, :request_times do
          section :hourly_yesterday_seed_activity_situation
          columns :tag, :activity_num, :activation_num, :request_num
        end

        field :avg_request_times do
          expr "? / ?", :request_times, :activity_num
        end

        clear_table do
          updated_at  params(:date).yesterday.to_s
        end
      end

      report :hourly_seed_activity_situation_yesterday_at_time do
        report_model Seed::ActivitySituationReport
        initialize_fields do
          record_time '昨日此时'
          report_type Seed::ActivityReport.to_s
          tag
        end
        field :activation_num do
          section :hourly_seed_activation_situation
          columns :activating_tag, :count_uid
        end

        field :activity_num, :request_times do
          section :hourly_yesterday_at_time_seed_activity_situation
          columns :tag, :count_distinct_sword_request_histories_uid, :count_sword_request_histories_id
        end

        field :avg_request_times do
          expr "? / ?", :request_times, :activity_num
        end

        after_save do
          System::TagGroup.reset_tags_options_cache(Seed::ActivitySituationReport,
            System::Constant::PICK_OPTIONS[Seed::ActivitySituationReport])
        end
      end

    end

end
