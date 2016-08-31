
ReportGenerator.configure do
  	section :seed_prop do
  		data_source SwordDs::Prop
      distinct_count :did
      condition do
        record_time params(:date).all_day
      end
      group :tag, :ro_pd_brand
      sum_group :tag, Distributers::TagDistributer
  	end

    section :seed_prop_succ do
      data_source SwordDs::Prop
      distinct_count "seed_feedback_histories.did"
      condition({"props.record_time" => params(:date).all_day})
      condition({"seed_feedback_histories.record_time" => params(:date).all_day})
      condition({"seed_feedback_histories.event_name" => 'solution_executed'})
      condition({"seed_feedback_histories.excuted_status" => 'Success'})
      join "inner join seed_feedback_histories on props.did = seed_feedback_histories.did"
      group :tag, :ro_pd_brand
      sum_group :tag, Distributers::TagDistributer
    end

  	report :seed_prop do
  		report_model Seed::PropReport
      initialize_fields do
        report_date params(:date)
        tag
        manufacturer
      end

      field :count do
        section :seed_prop
        columns :tag, :ro_pd_brand, :count_distinct_did
      end

      field :success_count do
        section :seed_prop_succ
        columns :tag, :ro_pd_brand, :count_distinct_seed_feedback_histories_did
      end

      before_save do |records|
        extend LimitRecordHelper
        brand_limit_records(records, :manufacturer, "厂商", 20)
      end

      after_save do
        System::TagGroup.reset_tags_options_cache(Seed::PropReport,
          System::Constant::PICK_OPTIONS[Seed::PropReport])
      end

      clear_table do
        report_date  params(:date)
      end
  	end
end
