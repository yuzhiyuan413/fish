ReportGenerator.configure do
  	section :hourly_seed_prop_detail do
  		data_source DailyDs::Prop
      distinct_count :did
      condition do
        record_time params(:date).all_day
      end
      group :tag, :ro_pd_brand, :ro_pd_model
      sum_group :tag, Distributers::TagDistributer
  	end

    section :hourly_seed_prop_detail_succ do
      data_source DailyDs::Prop
      distinct_count "seed_feedback_histories.did"
      condition({"props.record_time" => params(:date).all_day})
      condition({"seed_feedback_histories.record_time" => params(:date).all_day})
      condition({"seed_feedback_histories.event_name" => 'solution_executed'})
      condition({"seed_feedback_histories.excuted_status" => 'Success'})
      join "inner join seed_feedback_histories on props.did = seed_feedback_histories.did"
      group :tag, :ro_pd_brand, :ro_pd_model
      sum_group :tag, Distributers::TagDistributer
    end

  	report :hourly_seed_prop_detail do
  		report_model Seed::PropDetailReport
      initialize_fields do
        report_date params(:date)
        tag
        manufacturer
        board
      end

      field :count do
        section :hourly_seed_prop_detail
        columns :tag, :ro_pd_brand, :ro_pd_model, :count_distinct_did
      end

      field :success_count do
        section :hourly_seed_prop_detail_succ
        columns :tag, :ro_pd_brand, :ro_pd_model, :count_distinct_seed_feedback_histories_did
      end

			before_save do |records|
        extend LimitRecordHelper
				brand_limit_records(records, :board, "型号", 30)
			end

      after_save do
        System::TagGroup.reset_tags_options_cache(Seed::PropDetailReport,
          System::Constant::PICK_OPTIONS[Seed::PropDetailReport])
      end

      clear_table do
        report_date  params(:date)
      end
  	end
end
