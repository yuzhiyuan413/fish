class BeeDs::SeedApkMd5Alarm < ActiveRecord::Base
	establish_connection "dwh_sword_#{Rails.env}".to_sym
	def self.find_abnormal_tags
		select("distinct uid").group(:tag).count
	end

end
