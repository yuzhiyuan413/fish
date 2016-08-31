class DailyDs::TPhonearg < ActiveRecord::Base
	establish_connection "daily_ework_#{Rails.env}".to_sym
end