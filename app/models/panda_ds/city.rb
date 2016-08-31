class PandaDs::City < ActiveRecord::Base
	establish_connection "daily_panda_#{Rails.env}".to_sym
	extend RedisCacheHelper

	CITY_CACHE_KEY = 'charge_monitor_city'
	CITY_NAME_ID_MAP = "analysis_city_name_id"
	PROVINCE_NAME_ID_MAP = "analysis_province_name_id"
	OPERATOR_NAME_ID_MAP = "analysis_operator_name_id"

	def self.city_options
			Rails.cache.exist?(CITY_NAME_ID_MAP) ?
			Rails.cache.read(CITY_NAME_ID_MAP) :
				city_maps
	end

	def self.province_options
			Rails.cache.exist?(PROVINCE_NAME_ID_MAP) ?
			Rails.cache.read(PROVINCE_NAME_ID_MAP) :
				province_maps
	end

	def self.operator_options
			Rails.cache.exist?(OPERATOR_NAME_ID_MAP) ?
			Rails.cache.read(OPERATOR_NAME_ID_MAP) :
				operator_maps
	end

	def self.city_maps
		hash = select_hash(self)
		Rails.cache.write(CITY_NAME_ID_MAP,hash)
		hash
	end

	def self.province_maps
		hash = select_hash(PandaDs::Province)
		Rails.cache.write(PROVINCE_NAME_ID_MAP,hash)
		hash
	end

	def self.operator_maps
		hash = select_hash(PandaDs::Operator)
		Rails.cache.write(OPERATOR_NAME_ID_MAP,hash)
		hash
	end

	def self.select_hash(model)
		model.select(:id,:name).order(:name).inject({}){|result,i| result.merge({i.id.to_s=>i.name})}.merge!({"all" => "全部"})
	end

	def self.options
		Rails.cache.exist?(CITY_CACHE_KEY) ?
			Rails.cache.read(CITY_CACHE_KEY) :
				cities
	end

	def self.cities
		select(:id,:name,:province_id).order(:name).collect{|x|
			[x.name, x.id, x.province_id]}
	end

	def self.refresh_cache
		reset_cache(CITY_CACHE_KEY, cities)
	end
end
