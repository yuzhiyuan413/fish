class PandaDs::Operator < ActiveRecord::Base
	establish_connection "daily_panda_#{Rails.env}".to_sym
	extend RedisCacheHelper

	OPERATOR_CACHE_KEY = 'charge_monitor_operator'

	def self.options
		Rails.cache.exist?(OPERATOR_CACHE_KEY) ?
			Rails.cache.read(OPERATOR_CACHE_KEY) :
				operators
	end

	def self.operators
		select(:id,:name).order(:id).collect{|x| [x.name,x.id]}
	end

	def self.refresh_cache
		reset_cache(OPERATOR_CACHE_KEY, operators)
	end

end
