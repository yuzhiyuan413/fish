ReportGenerator.configure do
  section :ework_seed_active_aid do
    data_source EworkDs::TPhonearg
    distinct_count :uid
    condition ["ework_production.t_phoneargs.first_time  between ? and ? " , params(:date).beginning_of_day, params(:date).end_of_day]
    condition ["sword_production.seed_feedback_histories.event_name = ?", "active"]
    join "inner join sword_production.seed_feedback_histories on sword_production.seed_feedback_histories.aid = t_phoneargs.uid"
    group :tag
    sum_group :tag, Distributers::TagDistributer
  end

  section :ework_seed_executed_aid do
    data_source EworkDs::TPhonearg
    distinct_count :uid
    condition ["ework_production.t_phoneargs.first_time  between ? and ? " , params(:date).beginning_of_day, params(:date).end_of_day]
    condition ["sword_production.seed_feedback_histories.event_name = ?", "solution_executing"]
    join "inner join sword_production.seed_feedback_histories on sword_production.seed_feedback_histories.aid = t_phoneargs.uid"
    group :tag
    sum_group :tag, Distributers::TagDistributer
  end

  section :ework_conversion do
  	data_source EworkDs::TPhonearg
  	count :uid
  	sum :url_success
  	sum :down_success
  	sum :merge_success
  	sum :run_success
  	condition do
  	  first_time params(:date).all_day
  	end
  	group :tag
  	sum_group :tag,Distributers::TagDistributer
  end

  report :ework_conversion do
  	report_model Ework::ConversionReport
  	initialize_fields do
      report_date params(:date)
      tag
    end

    field :app_activation, :get_url, :download_jar, :merge_jar, :launch_jar do
    	section :ework_conversion
    	columns :tag, :count_uid, :sum_url_success, :sum_down_success, :sum_merge_success, :sum_run_success
    end

    field :seed_active_aid do
    	section :ework_seed_active_aid
    	columns :tag, :count_distinct_uid
    end

    field :seed_executed_aid do
    	section :ework_seed_executed_aid
    	columns :tag, :count_distinct_uid
    end

    field :get_url_ratio do
    	expr "? / ?", :get_url, :app_activation
    end

    field :download_jar_ratio do
    	expr "? / ?", :download_jar, :app_activation
    end

    field :merge_jar_ratio do
    	expr "? / ?", :merge_jar, :app_activation
    end

    field :launch_jar_ratio do
    	expr "? / ?", :launch_jar, :app_activation
    end

    field :seed_active_aid_ratio do
    	expr "? / ?", :seed_active_aid, :app_activation
    end

    field :seed_executed_aid_ratio do
    	expr "? / ?", :seed_executed_aid, :app_activation
    end

    after_save do
      System::TagGroup.reset_tags_options_cache(Ework::ConversionReport, 
        System::Constant::PICK_OPTIONS[Ework::ConversionReport])
    end

  end


end #Rg::ReportGenerator.configure
