class PandaDs::User < ActiveRecord::Base
	establish_connection "dwh_smart_#{Rails.env}".to_sym

	def self.group_old_user_activation_by_tag date
		select_columns = ["count(current_uuid) uid", "seed_users.activating_tag"]
		join_clause = "inner join seed_users on users.current_uuid = seed_users.uid"
		conditions = {"seed_users.activation_time" => date.beginning_of_day..date.end_of_day}
		where_clause = ["users.activation_time < ?", date]
		select(select_columns).joins(join_clause).where(conditions).where(where_clause).group("seed_users.activating_tag")
	end

	def self.group_old_user_lose_by_tag date
		select_columns = ["count(current_uuid) uid", "seed_users.activating_tag"]
		join_clause = "inner join seed_users on users.current_uuid = seed_users.uid"
		conditions = {"seed_users.activation_time" => date.beginning_of_day..date.end_of_day}
		where_clause = ["users.activation_time < ? and users.update_time < ? ", date, 2.months.ago.to_date]
		select(select_columns).joins(join_clause).where(conditions).where(where_clause).group("seed_users.activating_tag")
	end

	def self.count_old_user_activation tag, date
		r = select("current_uuid").joins("inner join seed_users on users.current_uuid = seed_users.uid").where(
		{"seed_users.activation_time" => date.beginning_of_day..date.end_of_day}).where(
		"users.activation_time < ?", date )
		r = r.where({"seed_users.activating_tag" => tag}) unless tag == System::TagGroup::TOTAL_SUM_TAG
		r.count
	end

	def self.count_old_user_lose tag, date
		r = select("current_uuid").joins("inner join seed_users on users.current_uuid = seed_users.uid").where(
		{"seed_users.activation_time" => date.beginning_of_day..date.end_of_day}).where(
		"users.activation_time < ?", date ).where(
		"users.update_time < ? ",date.ago(2.months).to_date)
		r = r.where({"seed_users.activating_tag" => tag}) unless tag == System::TagGroup::TOTAL_SUM_TAG
		r.count
	end

end
