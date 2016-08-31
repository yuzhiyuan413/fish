
ReportGenerator.configure do
  	section :seed_prop_detail_month do
  		data_source SwordDs::Prop
      distinct_count :did
      condition do
        record_time params(:date).beginning_of_month.beginning_of_day..params(:date).end_of_month.end_of_day
      end
      group :tag, :ro_pd_brand, :ro_pd_model
      sum_group :tag, Distributers::TagDistributer
  	end

    section :seed_prop_detail_month_succ do
      data_source SwordDs::Prop
      distinct_count "seed_feedback_histories.did"
      condition({"props.record_time" => params(:date).beginning_of_month.beginning_of_day..params(:date).end_of_month.end_of_day})
      condition({"seed_feedback_histories.record_time" => params(:date).beginning_of_month.beginning_of_day..params(:date).end_of_month.end_of_day})
      condition({"seed_feedback_histories.event_name" => 'solution_executed'})
      condition({"seed_feedback_histories.excuted_status" => 'Success'})
      join "inner join seed_feedback_histories on props.did = seed_feedback_histories.did"
      group :tag, :ro_pd_brand, :ro_pd_model
      sum_group :tag, Distributers::TagDistributer
    end

  	report :seed_prop_detail_month do
  		report_model Seed::PropDetailMonthlyReport
      initialize_fields do
        report_date params(:date).strftime("%Y/%m")
        tag
        manufacturer
        board
      end

      field :count do
        section :seed_prop_detail_month
        columns :tag, :ro_pd_brand, :ro_pd_model, :count_distinct_did
      end

      field :success_count do
        section :seed_prop_detail_month_succ
        columns :tag, :ro_pd_brand, :ro_pd_model, :count_distinct_seed_feedback_histories_did
      end

      before_save do |records|
        extend LimitRecordHelper
        brand_limit_records(records, :board, "型号", 200)
      end

      after_save do
        System::TagGroup.reset_tags_options_cache(Seed::PropDetailMonthlyReport,
          System::Constant::PICK_OPTIONS[Seed::PropDetailMonthlyReport])
      end

      clear_table do
        report_date  params(:date).strftime("%Y/%m")
      end
  	end
end
