class BeeDs::RequestHistory < ActiveRecord::Base
	establish_connection "dwh_smart_#{Rails.env}".to_sym
	self.table_name = :seed_request_histories
	self.primary_key = "id"

	def self.stay_alive_records activation_date, stay_alive_date
		select_columns = ["count(distinct seed_users.uid) uid", "seed_users.activating_tag tag"]
		join_clause = "inner join seed_users on seed_users.uid = request_histories.uid"
		conditions = {
			:record_time => (stay_alive_date.beginning_of_day..stay_alive_date.end_of_day),
			"seed_users.activation_time" => (activation_date.beginning_of_day..activation_date.end_of_day)
		}
		select(select_columns).joins(join_clause).where(conditions).group("seed_users.activating_tag")
	end

	def self.count_stay_alive tag, activation_date, stay_alive_date
		select_clause = "distinct seed_users.uid"
		join_clause = "inner join seed_users on seed_users.uid = request_histories.uid"
		conditions = {
			:record_time => (stay_alive_date.beginning_of_day..stay_alive_date.end_of_day),
			"seed_users.activation_time" => (activation_date.beginning_of_day..activation_date.end_of_day)
		}
		conditions["seed_users.activating_tag"] = tag unless tag.eql? System::TagGroup::TOTAL_SUM_TAG
		select(select_clause).joins(join_clause).where(conditions).count
	end

	def self.count_activity tag, begin_time, end_time = begin_time.end_of_day
		select_clause = "distinct request_histories.uid"
		join_clause = "inner join seed_users on seed_users.uid = request_histories.uid"
		conditions = { :record_time => (begin_time..end_time)}
		conditions["seed_users.activating_tag"] = tag unless tag.eql? System::TagGroup::TOTAL_SUM_TAG
		select(select_clause).joins(join_clause).where(conditions).count
	end

	def self.count_embed tag, begin_time, end_time = begin_time.end_of_day
		select_clause = "distinct request_histories.uid"
		join_clause = "inner join seed_users on seed_users.uid = request_histories.uid"
		conditions = { :record_time => (begin_time..end_time)}
		conditions[:appstate] = [0,1]
		conditions["seed_users.activating_tag"] = tag unless tag.eql? System::TagGroup::TOTAL_SUM_TAG
		select(select_clause).joins(join_clause).where(conditions).count
	end

	def self.count_sign tag, begin_time, end_time = begin_time.end_of_day
		select_clause = "distinct request_histories.uid"
		join_clause = "inner join seed_users on seed_users.uid = request_histories.uid"
		conditions = { :record_time => (begin_time..end_time)}
		conditions["request_histories.sysa"] = 1
		conditions["seed_users.activating_tag"] = tag unless tag.eql? System::TagGroup::TOTAL_SUM_TAG
		select(select_clause).joins(join_clause).where(conditions).count
	end

	def self.count_request tag, begin_time, end_time = begin_time.end_of_day
		select_clause = "id"
		join_clause = "inner join seed_users on seed_users.uid = request_histories.uid"
		conditions = { :record_time => (begin_time..end_time)}
		conditions["seed_users.activating_tag"] = tag unless tag.eql? System::TagGroup::TOTAL_SUM_TAG
		select(select_clause).joins(join_clause).where(conditions).count
	end

	def self.group_activity_by_tag begin_time, end_time
		record_time_condition = {"request_histories.record_time" => (begin_time..end_time) }
		group_columns = ["seed_users.activating_tag"]
		select_columns = ["seed_users.activating_tag tag", "count(request_histories.id) id", "count(distinct request_histories.uid) uid"]
		joins_clause = "inner join seed_users on seed_users.uid = request_histories.uid"
		select(select_columns).joins(joins_clause).where(record_time_condition).group(group_columns)
	end

	def self.group_activity_num_by_tag begin_time, end_time
		record_time_condition = {"request_histories.record_time" => (begin_time..end_time) }
		group_columns = ["seed_users.activating_tag"]
		select_columns = ["seed_users.activating_tag tag", "count(distinct request_histories.uid) uid"]
		joins_clause = "inner join seed_users on seed_users.uid = request_histories.uid"
		select(select_columns).joins(joins_clause).where(record_time_condition).group(group_columns)
	end

	def self.group_embed_by_tag record_date=Date.today
		where_condition = {"request_histories.record_time" => (record_date.beginning_of_day..record_date.end_of_day) }
		where_condition[:appstate] = [0,1]
		group_columns = ["seed_users.activating_tag"]
		select_columns = ["seed_users.activating_tag tag", "count(distinct request_histories.uid) uid"]
		joins_clause = "inner join seed_users on seed_users.uid = request_histories.uid"
		select(select_columns).joins(joins_clause).where(where_condition).group(group_columns)
	end

	def self.group_sign_by_tag record_date=Date.today
		where_condition = {"request_histories.record_time" => (record_date.beginning_of_day..record_date.end_of_day) }
		where_condition["request_histories.sysa"] = 1
		group_columns = ["seed_users.activating_tag"]
		select_columns = ["seed_users.activating_tag tag", "count(distinct request_histories.uid) uid"]
		joins_clause = "inner join seed_users on seed_users.uid = request_histories.uid"
		select(select_columns).joins(joins_clause).where(where_condition).group(group_columns)
	end

	private
	def self.get_table_name
		"request_histories"
	end

end
