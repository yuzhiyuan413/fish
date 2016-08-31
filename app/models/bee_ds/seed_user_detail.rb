class BeeDs::SeedUserDetail < ActiveRecord::Base
	establish_connection "dwh_smart_#{Rails.env}".to_sym
	belongs_to :seed_user
end
