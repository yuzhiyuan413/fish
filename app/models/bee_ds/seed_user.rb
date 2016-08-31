class BeeDs::SeedUser < ActiveRecord::Base
	establish_connection "dwh_smart_#{Rails.env}".to_sym 
	self.primary_key = "id"

	def self.group_old_user_activity_by_tag begin_time, end_time
		select_columns = ["count(distinct seed_users.uid) uid", "seed_users.activating_tag"]
		join_clause = "inner join smart_production.request_histories on seed_users.uid = smart_production.request_histories.current_uuid"
		conditions = { "seed_users.activation_time" => (begin_time..end_time)}
		condition_clause = ["smart_production.request_histories.record_time between ? and ? ",
			begin_time.to_time.localtime.ago(2.months), begin_time.to_time.end_of_day.ago(1.day)]
		select(select_columns).joins(join_clause).where(conditions).where(condition_clause).group("seed_users.activating_tag")
	end 

	def self.cross_panda_group_activation_by_tag begin_time, end_time
		select_columns = ["count(distinct seed_users.uid) uid", "seed_users.activating_tag"]
		join_clause = "inner join users on seed_users.uid = users.current_uuid"
		conditions = {
			"seed_users.activation_time" => (begin_time..end_time),
			"users.activation_time" => (begin_time..end_time)
		}
		select(select_columns).joins(join_clause).where(conditions).group("seed_users.activating_tag")
	end

	def self.group_sign_by_tag begin_time, end_time
		select_columns = ["count(uid) uid", :activating_tag]
		conditions = {
			:activation_time => (begin_time..end_time),
			:sysa => 1
		}
		select(select_columns).where(conditions).group(:activating_tag)
	end

	def self.group_reset_by_tag begin_time, end_time
		select_columns = ["count(seed_users.uid) uid", "seed_users.activating_tag"]
		conditions = { :activation_time => (begin_time..end_time)	}
		where_clause = "reset_count > 0"
		select(select_columns).joins(:seed_user_details).where(
			conditions).where(where_clause).group("seed_users.activating_tag")
	end

	def self.count_old_user_activity tag, begin_time, end_time = begin_time.end_of_day
		select_columns = "distinct seed_users.uid"
		join_clause = "inner join smart_production.request_histories on seed_users.uid = smart_production.request_histories.current_uuid"
		conditions = { "seed_users.activation_time" => (begin_time..end_time)}
		conditions[:activating_tag] = tag unless tag.eql? System::TagGroup::TOTAL_SUM_TAG
		condition_clause = ["smart_production.request_histories.record_time between ? and ? ",
			begin_time.to_time.localtime.ago(3.months), begin_time.to_time.end_of_day.ago(1.day)]
		select(select_columns).joins(join_clause).where(conditions).where(condition_clause).count
	end

	def self.count_activation tag, begin_time, end_time = begin_time.end_of_day
		select_clause = "distinct uid"
		conditions = { :activation_time => (begin_time..end_time)}
		conditions[:activating_tag] = tag unless tag.eql? System::TagGroup::TOTAL_SUM_TAG
		select(select_clause).where(conditions).count
	end

	def self.count_activation_cross_panda tag, begin_time, end_time = begin_time.end_of_day
		select_clause = "distinct uid"
		join_clause = "inner join users on seed_users.uid = users.current_uuid"
		conditions = {
			"seed_users.activation_time" => (begin_time..end_time),
			"users.activation_time" => (begin_time..end_time)
		}
		conditions["seed_users.activating_tag"] = tag unless tag.eql? System::TagGroup::TOTAL_SUM_TAG
		select(select_clause).joins(join_clause).where(conditions).count
  end

	def self.count_signature tag, begin_time, end_time = begin_time.end_of_day
		select_clause = "distinct uid"
		conditions = {
			:activation_time => (begin_time..end_time),
			:sysa => 1
		}
		conditions[:activating_tag] = tag unless tag.eql? System::TagGroup::TOTAL_SUM_TAG
		select(select_clause).where(conditions).count
	end

	def self.count_reset_num tag, begin_time, end_time = begin_time.end_of_day
		select_clause = "distinct seed_users.uid"
		where_clause = "reset_count > 0"
		conditions = { :activation_time => (begin_time..end_time)	}
		conditions[:activating_tag] = tag unless tag.eql? System::TagGroup::TOTAL_SUM_TAG
		select(select_clause).joins(:seed_user_details).where(conditions).where(where_clause).count
	end

	def self.total_count_activation tag
		select_clause = "distinct uid"
		conditions = {}
		conditions[:activating_tag] = tag unless tag.eql? System::TagGroup::TOTAL_SUM_TAG
		select("distinct uid").where(conditions).count
	end

	def self.group_activation_by_tag begin_time, end_time
		select_columns = ["seed_users.activating_tag", "count(seed_users.uid) uid"]
		where_condition = {"seed_users.activation_time" => (begin_time..end_time) }
		group_columns = ["seed_users.activating_tag"]
		select(select_columns).where(where_condition).group(group_columns)
	end

	def self.group_total_activation_by_tag
		group_columns = ["seed_users.activating_tag"]
		select_columns = ["seed_users.activating_tag", "count(seed_users.uid) uid"]
		select(select_columns).group(group_columns)
	end

	def self.group_charge_user_conversion_by_tag begin_time, end_time = begin_time.end_of_day
		select_columns = ["seed_users.activating_tag", "count(distinct seed_users.uid) uid"]
		join_clause = "inner join smart_production.request_histories on smart_production.request_histories.current_uuid = seed_users.uid"
		conditions = {"seed_users.activation_time" => (begin_time..end_time)}
		where_clause = ["smart_production.request_histories.tag != 'distillery'
										and smart_production.request_histories.record_time > ? ", begin_time]
		group_columns = ["seed_users.activating_tag"]
		select(select_columns).joins(join_clause).where(conditions).where(where_clause).group(group_columns)
	end

	def self.v9_activation_num tag, begin_time, end_time = begin_time.end_of_day
		select_columns = "distinct seed_users.uid"
		join_clause = "inner join smart_production.request_histories on smart_production.request_histories.current_uuid = seed_users.uid"
		conditions = {"seed_users.activation_time" => (begin_time..end_time)}
		where_clause = ["smart_production.request_histories.tag != 'distillery'
										and smart_production.request_histories.record_time > ? ", begin_time]
		conditions["seed_users.activating_tag"] = tag unless tag.eql? System::TagGroup::TOTAL_SUM_TAG
		select(select_columns).joins(join_clause).where(conditions).where(where_clause).count
	end


end
