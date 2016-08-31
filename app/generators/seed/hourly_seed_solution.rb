ReportGenerator.configure do
    section :hourly_seed_solution_active_solution_summary do
      data_source DailyDs::SeedFeedbackHistory
      condition do
        record_time params(:date).all_day
        event_name "active"
      end
      distinct_count :did
      group :tag
      sum_group :tag, Distributers::TagDistributer
    end

    section :hourly_seed_solution_execting_solution_summary do
      data_source DailyDs::SeedFeedbackHistory
      condition do
        record_time params(:date).all_day
        event_name "solution_executing"
      end
      distinct_count :did
      group :tag
      sum_group :tag, Distributers::TagDistributer
    end

    section :hourly_seed_solution_executed_solution_summary do
      data_source DailyDs::SeedFeedbackHistory
      condition do
        record_time params(:date).all_day
        event_name "solution_executed"
      end
      distinct_count :did
      group :tag
      sum_group :tag, Distributers::TagDistributer
    end

    section :hourly_seed_solution_canceled_solution_summary do
      data_source DailyDs::SeedFeedbackHistory
      condition do
        record_time params(:date).all_day
        event_name "solutionCanceled"
      end
      distinct_count :did
      group :tag
      sum_group :tag, Distributers::TagDistributer
    end

    section :hourly_seed_solution_successed_solution_summary do
      data_source DailyDs::SeedFeedbackHistory
      condition do
        record_time params(:date).all_day
        event_name "solution_executed"
        excuted_status "Success"
      end
      distinct_count :did
      group :tag
      sum_group :tag, Distributers::TagDistributer
    end

    section :hourly_seed_solution_installed_solution_summary do
      data_source DailyDs::SeedFeedbackHistory
      condition do
        record_time params(:date).all_day
        event_name "solution_executed"
        nut_code [0,16,17,2,4]
      end
      distinct_count :did
      group :tag
      sum_group :tag, Distributers::TagDistributer
    end

     section :hourly_seed_solution_new_installed_solution_summary do
      data_source DailyDs::SeedFeedbackHistory
      condition do
        record_time params(:date).all_day
        event_name "solution_executed"
        nut_code [0,16,17]
      end
      distinct_count :did
      group :tag
      sum_group :tag, Distributers::TagDistributer
    end

    section :hourly_seed_solution_v8_exists_solution_summary do
      data_source DailyDs::SeedFeedbackHistory
      condition do
        record_time params(:date).all_day
        event_name "solution_executed"
        nut_code [2]
      end
      distinct_count :did
      group :tag
      sum_group :tag, Distributers::TagDistributer
    end

    section :hourly_seed_solution_v9_exists_solution_summary do
      data_source DailyDs::SeedFeedbackHistory
      condition do
        record_time params(:date).all_day
        event_name "solution_executed"
        nut_code [4]
      end
      distinct_count :did
      group :tag
      sum_group :tag, Distributers::TagDistributer
    end

    section :hourly_seed_solution_active do
      data_source DailyDs::SeedFeedbackHistory
      condition do
        record_time params(:date).all_day
        event_name "active"
      end
      distinct_count :did
      group :tag, :solution_id
      sum_group :tag, Distributers::TagDistributer
    end

    section :hourly_seed_solution_execting do
      data_source DailyDs::SeedFeedbackHistory
      condition do
        record_time params(:date).all_day
        event_name "solution_executing"
      end
      distinct_count :did
      group :tag, :solution_id
      sum_group :tag, Distributers::TagDistributer
    end

    section :hourly_seed_solution_executed do
      data_source DailyDs::SeedFeedbackHistory
      condition do
        record_time params(:date).all_day
        event_name "solution_executed"
      end
      distinct_count :did
      group :tag, :solution_id
      sum_group :tag, Distributers::TagDistributer
    end

    section :hourly_seed_solution_canceled do
      data_source DailyDs::SeedFeedbackHistory
      condition do
        record_time params(:date).all_day
        event_name "solutionCanceled"
      end
      distinct_count :did
      group :tag, :solution_id
      sum_group :tag, Distributers::TagDistributer
    end

    section :hourly_seed_solution_successed do
      data_source DailyDs::SeedFeedbackHistory
      condition do
        record_time params(:date).all_day
        event_name "solution_executed"
        excuted_status "Success"
      end
      distinct_count :did
      group :tag, :solution_id
      sum_group :tag, Distributers::TagDistributer
    end

    section :hourly_seed_solution_installed do
      data_source DailyDs::SeedFeedbackHistory
      condition do
        record_time params(:date).all_day
        event_name "solution_executed"
        nut_code [0,16,17,2,4]
      end
      distinct_count :did
      group :tag, :solution_id
      sum_group :tag, Distributers::TagDistributer
    end

    section :hourly_seed_solution_new_installed do
      data_source DailyDs::SeedFeedbackHistory
      condition do
        record_time params(:date).all_day
        event_name "solution_executed"
        nut_code [0,16,17]
      end
      distinct_count :did
      group :tag, :solution_id
      sum_group :tag, Distributers::TagDistributer
    end
    section :hourly_seed_solution_v8_exists do
      data_source DailyDs::SeedFeedbackHistory
      condition do
        record_time params(:date).all_day
        event_name "solution_executed"
        nut_code [2]
      end
      distinct_count :did
      group :tag, :solution_id
      sum_group :tag, Distributers::TagDistributer
    end

    section :hourly_seed_solution_v9_exists do
      data_source DailyDs::SeedFeedbackHistory
      condition do
        record_time params(:date).all_day
        event_name "solution_executed"
        nut_code [4]
      end
      distinct_count :did
      group :tag, :solution_id
      sum_group :tag, Distributers::TagDistributer
    end

    group :hourly_seed_solution_group do
      report :hourly_seed_solution_summary do
        report_model Seed::SolutionReport
        initialize_fields do
          report_date params(:date)
          plan_id 0
          tag
        end

        field :active_count do
          section :hourly_seed_solution_active_solution_summary
          columns :tag, :count_distinct_did
        end

        field :execting_count do
          section :hourly_seed_solution_execting_solution_summary
          columns :tag, :count_distinct_did
        end

        field :exected_count do
          section :hourly_seed_solution_executed_solution_summary
          columns :tag, :count_distinct_did
        end

        field :canceled_count do
          section :hourly_seed_solution_canceled_solution_summary
          columns :tag, :count_distinct_did
        end

        field :success_count do
          section :hourly_seed_solution_successed_solution_summary
          columns :tag, :count_distinct_did
        end

        field :installed_count do
          section :hourly_seed_solution_installed_solution_summary
          columns :tag, :count_distinct_did
        end

        field :new_installed_count do
          section :hourly_seed_solution_new_installed_solution_summary
          columns :tag, :count_distinct_did
        end

        field :v8_exists_count do
          section :hourly_seed_solution_v8_exists_solution_summary
          columns :tag, :count_distinct_did
        end

        field :v9_exists_count do
          section :hourly_seed_solution_v9_exists_solution_summary
          columns :tag, :count_distinct_did
        end

        field :return_ratio do
          expr "? / ?", :exected_count, :execting_count
        end

        field :success_ratio do
          expr "? / ?", :success_count, :exected_count
        end

        field :installed_ratio do
          expr "? / ?", :installed_count, :success_count
        end

        field :new_installed_ratio do
          expr "? / ?", :new_installed_count, :success_count
        end

        field :v8_exists_ratio do
          expr "? / ?", :v8_exists_count, :success_count
        end

        field :v9_exists_ratio do
          expr "? / ?", :v9_exists_count, :success_count
        end
      end

      report :hourly_seed_solution do
        report_model Seed::SolutionReport
        initialize_fields do
          report_date params(:date)
          tag
          plan_id
        end

        field :execting_count do
          section :hourly_seed_solution_execting
          columns :tag, :solution_id, :count_distinct_did
        end

        field :exected_count do
          section :hourly_seed_solution_executed
          columns :tag, :solution_id, :count_distinct_did
        end

        field :canceled_count do
          section :hourly_seed_solution_canceled
          columns :tag, :solution_id, :count_distinct_did
        end

        field :success_count do
          section :hourly_seed_solution_successed
          columns :tag, :solution_id, :count_distinct_did
        end

        field :installed_count do
          section :hourly_seed_solution_installed
          columns :tag, :solution_id, :count_distinct_did
        end

        field :new_installed_count do
          section :hourly_seed_solution_new_installed
          columns :tag, :solution_id, :count_distinct_did
        end

        field :v8_exists_count do
          section :hourly_seed_solution_v8_exists
          columns :tag, :solution_id, :count_distinct_did
        end

        field :v9_exists_count do
          section :hourly_seed_solution_v9_exists
          columns :tag, :solution_id, :count_distinct_did
        end

        field :return_ratio do
          expr "? / ?", :exected_count, :execting_count
        end

        field :success_ratio do
          expr "? / ?", :success_count, :exected_count
        end

        field :installed_ratio do
          expr "? / ?", :installed_count, :success_count
        end

        field :new_installed_ratio do
          expr "? / ?", :new_installed_count, :success_count
        end

        field :v8_exists_ratio do
          expr "? / ?", :v8_exists_count, :success_count
        end

        field :v9_exists_ratio do
          expr "? / ?", :v9_exists_count, :success_count
        end

        after_save do
          extend LimitRecordHelper
          update_solution_succ_proportion_ratio(params(:date))
          System::TagGroup.reset_tags_options_cache(Seed::SolutionReport,
            System::Constant::PICK_OPTIONS[Seed::SolutionReport])
        end
      end
    end
end
