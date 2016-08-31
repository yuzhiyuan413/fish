include LimitRecordHelper
ReportGenerator.configure do
  	section :seed_device_detail do
  		data_source SwordDs::SeedFeedbackHistory
      distinct_count :did
      condition do
        record_time params(:date).all_day
      end
      group :tag, :brand, :model
      sum_group :tag, Distributers::TagDistributer
  	end

    section :seed_device_detail_succ do
      data_source SwordDs::SeedFeedbackHistory
      distinct_count :did
      condition do
        record_time params(:date).all_day
        event_name 'solution_executed'
        excuted_status 'Success'
      end
      group :tag, :brand, :model
      sum_group :tag, Distributers::TagDistributer
    end

  	report :seed_device_detail do
  		report_model Seed::DeviceDetailReport
      initialize_fields do
        report_date params(:date)
        tag
        brand
        model
      end

      field :count do
        section :seed_device_detail
        columns :tag, :brand, :model, :count_distinct_did
      end

      field :success_count do
        section :seed_device_detail_succ
        columns :tag, :brand, :model, :count_distinct_did
      end

      before_save do |records|
        brand_limit_records(records, :model, "型号", 30)
      end

      after_save do
        System::TagGroup.reset_tags_options_cache(Seed::DeviceDetailReport,
          System::Constant::PICK_OPTIONS[Seed::DeviceDetailReport])
      end

      clear_table do
        report_date  params(:date)
      end
  	end

end
