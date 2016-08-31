class PandaDs::Province < ActiveRecord::Base
	establish_connection "daily_panda_#{Rails.env}".to_sym
	extend RedisCacheHelper

	PROVINCE_CACHE_KEY = 'charge_monitor_province'

	def self.options
		Rails.cache.exist?(PROVINCE_CACHE_KEY) ?
			Rails.cache.read(PROVINCE_CACHE_KEY) :
				provinces
	end

	def self.provinces
		select(:id,:name).order(:name).collect{|x| [x.name,x.id]}
	end

	def self.refresh_cache
		reset_cache(PROVINCE_CACHE_KEY, provinces)
	end
end
