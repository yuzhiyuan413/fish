ReportGenerator.configure do
	section :seed_activation_aid do
		data_source SwordDs::AidUser
		distinct_count "aid_users.aid"
		condition do
			record_time params(:date).all_day
		end
		group :tag
		sum_group :tag, Distributers::TagDistributer
	end

	section :seed_cross_solution_active do
		data_source SwordDs::AidUser
		distinct_count "aid_users.aid"
		condition ["sword_production.aid_users.record_time between ? and ?", params(:date).beginning_of_day, params(:date).end_of_day]
		condition ["sword_production.seed_feedback_histories.record_time > ?", params(:date).beginning_of_day]
		condition ["sword_production.seed_feedback_histories.event_name = ?", "active"]
		join "inner join sword_production.seed_feedback_histories on sword_production.seed_feedback_histories.aid = aid_users.aid"
		group :tag
    	sum_group :tag, Distributers::TagDistributer
	end

	section :seed_cross_solution_executing do
		data_source SwordDs::AidUser
		distinct_count "aid_users.aid"
		condition ["sword_production.aid_users.record_time between ? and ?", params(:date).beginning_of_day, params(:date).end_of_day]
		condition ["sword_production.seed_feedback_histories.record_time > ?", params(:date).beginning_of_day]
		condition ["sword_production.seed_feedback_histories.event_name = ?", "solution_executing"]
		join "inner join sword_production.seed_feedback_histories on sword_production.seed_feedback_histories.aid = aid_users.aid"
		group :tag
    	sum_group :tag, Distributers::TagDistributer
	end

	section :seed_cross_solution_executied do
		data_source SwordDs::AidUser
		distinct_count "aid_users.aid"
		condition ["sword_production.aid_users.record_time between ? and ?", params(:date).beginning_of_day, params(:date).end_of_day]
		condition ["sword_production.seed_feedback_histories.record_time > ?", params(:date).beginning_of_day]
		condition ["sword_production.seed_feedback_histories.event_name = ?", "solution_executed"]
		join "inner join sword_production.seed_feedback_histories on sword_production.seed_feedback_histories.aid = aid_users.aid"
		group :tag
    	sum_group :tag, Distributers::TagDistributer
	end

	section :seed_cross_solution_successed do
		data_source SwordDs::AidUser
		distinct_count "aid_users.aid"
		condition ["sword_production.aid_users.record_time between ? and ?", params(:date).beginning_of_day, params(:date).end_of_day]
		condition ["sword_production.seed_feedback_histories.record_time > ?", params(:date).beginning_of_day]
		condition ["sword_production.seed_feedback_histories.event_name = ?", "solution_executed"]
		condition ["sword_production.seed_feedback_histories.excuted_status = 'Success'"]
		join "inner join sword_production.seed_feedback_histories on sword_production.seed_feedback_histories.aid = aid_users.aid"
		group :tag
    	sum_group :tag, Distributers::TagDistributer
	end

	section :seed_cross_solution_installed do
		data_source SwordDs::AidUser
		distinct_count "aid_users.aid"
		condition ["sword_production.aid_users.record_time between ? and ?", params(:date).beginning_of_day, params(:date).end_of_day]
		condition ["sword_production.seed_feedback_histories.record_time > ?", params(:date).beginning_of_day]
		condition ["sword_production.seed_feedback_histories.event_name = ?", "solution_executed"]
		condition ["sword_production.seed_feedback_histories.nut_code in (0,16,17)"]
		join "inner join sword_production.seed_feedback_histories on sword_production.seed_feedback_histories.aid = aid_users.aid"
		group :tag
    	sum_group :tag, Distributers::TagDistributer
	end

	section :seed_cross_solution_started do
		data_source SwordDs::AidUser
		distinct_count "aid_users.aid"
		condition ["sword_production.aid_users.record_time between ? and ?", params(:date).beginning_of_day, params(:date).end_of_day]
		condition ["sword_production.seed_feedback_histories.record_time > ?", params(:date).beginning_of_day]
		condition ["sword_production.seed_feedback_histories.event_name = ?", "solution_executed"]
		condition ["sword_production.seed_feedback_histories.nut_code in (0,17)"]
		join "inner join sword_production.seed_feedback_histories on sword_production.seed_feedback_histories.aid = aid_users.aid"
		group :tag
    	sum_group :tag, Distributers::TagDistributer
	end

	section :seed_cross_solution_failed do
		data_source SwordDs::AidUser
		distinct_count "aid_users.aid"
		condition ["sword_production.aid_users.record_time between ? and ?", params(:date).beginning_of_day, params(:date).end_of_day]
		condition ["sword_production.seed_feedback_histories.record_time > ?", params(:date).beginning_of_day]
		condition ["sword_production.seed_feedback_histories.event_name = ?", "solution_executed"]
		condition ["sword_production.seed_feedback_histories.nut_code not in (0,2,4,16,17)"]
		join "inner join sword_production.seed_feedback_histories on sword_production.seed_feedback_histories.aid = aid_users.aid"
		group :tag
    	sum_group :tag, Distributers::TagDistributer
	end

	section :seed_cross_solution_v8 do
		data_source SwordDs::AidUser
		distinct_count "aid_users.aid"
		condition ["sword_production.aid_users.record_time between ? and ?", params(:date).beginning_of_day, params(:date).end_of_day]
		condition ["sword_production.seed_feedback_histories.record_time > ?", params(:date).beginning_of_day]
		condition ["sword_production.seed_feedback_histories.event_name = ?", "solution_executed"]
		condition ["sword_production.seed_feedback_histories.nut_code = 2"]
		join "inner join sword_production.seed_feedback_histories on sword_production.seed_feedback_histories.aid = aid_users.aid"
		group :tag
    	sum_group :tag, Distributers::TagDistributer
	end

	section :seed_cross_solution_v9 do
		data_source SwordDs::AidUser
		distinct_count "aid_users.aid"
		condition ["sword_production.aid_users.record_time between ? and ?", params(:date).beginning_of_day, params(:date).end_of_day]
		condition ["sword_production.seed_feedback_histories.record_time > ?", params(:date).beginning_of_day]
		condition ["sword_production.seed_feedback_histories.event_name = ?", "solution_executed"]
		condition ["sword_production.seed_feedback_histories.nut_code = 4"]
		join "inner join sword_production.seed_feedback_histories on sword_production.seed_feedback_histories.aid = aid_users.aid"
		group :tag
    	sum_group :tag, Distributers::TagDistributer
	end

	section :seed_cross_v9_activity do
		data_source SwordDs::AidUser
		distinct_count "aid_users.aid"
		condition ["sword_production.aid_users.record_time between ? and ?", params(:date).beginning_of_day, params(:date).end_of_day]
		condition ["smart_v9_production.request_histories.server_time > ?", params(:date).beginning_of_day]
		join "inner join smart_v9_production.request_histories on smart_v9_production.request_histories.aid = aid_users.aid"
		group :tag
		sum_group :tag, Distributers::TagDistributer
	end

	report :seed_arrival do
		report_model Seed::ArrivalReport
	    initialize_fields do
	      report_date params(:date)
	      tag
	    end

	    field :seed_activation  do
	      section :seed_activation_aid
	      columns :tag, :count_distinct_aid_users_aid
	    end

        field :seed_active  do
	      section :seed_cross_solution_active
	      columns :tag, :count_distinct_aid_users_aid
	    end

	    field :seed_executing  do
	      section :seed_cross_solution_executing
	      columns :tag, :count_distinct_aid_users_aid
	    end

	    field :seed_executied  do
	      section :seed_cross_solution_executied
	      columns :tag, :count_distinct_aid_users_aid
	    end

	    field :seed_successed  do
	      section :seed_cross_solution_successed
	      columns :tag, :count_distinct_aid_users_aid
	    end

	    field :seed_installed  do
	      section :seed_cross_solution_installed
	      columns :tag, :count_distinct_aid_users_aid
	    end

	    field :seed_started  do
	      section :seed_cross_solution_started
	      columns :tag, :count_distinct_aid_users_aid
	    end

	    field :seed_failed  do
	      section :seed_cross_solution_failed
	      columns :tag, :count_distinct_aid_users_aid
	    end

	    field :seed_v8_exists  do
	      section :seed_cross_solution_v8
	      columns :tag, :count_distinct_aid_users_aid
	    end

	    field :seed_v9_exists  do
	      section :seed_cross_solution_v9
	      columns :tag, :count_distinct_aid_users_aid
	    end

	    field :v9_activity  do
	      section :seed_cross_v9_activity
	      columns :tag, :count_distinct_aid_users_aid
	    end

	    field :seed_active_ratio do
	    	expr "? / ?", :seed_active, :seed_activation
	    end

        field :seed_executing_ratio do
	      expr "? / ?", :seed_executing, :seed_activation
	    end

	    field :seed_executied_ratio do
	      expr "? / ?", :seed_executied, :seed_activation
	    end

	    field :seed_successed_ratio do
	      expr "? / ?", :seed_successed, :seed_activation
	    end

	    field :seed_installed_ratio do
	      expr "? / ?", :seed_installed, :seed_activation
	    end

	    field :seed_started_ratio do
	      expr "? / ?", :seed_started, :seed_activation
	    end

			field :seed_failed_ratio do
	      expr "? / ?", :seed_failed, :seed_successed
	    end

	    field :seed_v8_exists_ratio do
	      expr "? / ?", :seed_v8_exists, :seed_successed
	    end

			field :seed_v9_exists_ratio do
	      expr "? / ?", :seed_v9_exists, :seed_successed
	    end

	    field :v9_activity_ratio do
	      expr "? / ?", :v9_activity, :seed_activation
	    end

			after_save do
				System::TagGroup.reset_tags_options_cache(Seed::ArrivalReport,
					System::Constant::PICK_OPTIONS[Seed::ArrivalReport])
			end
	end
end