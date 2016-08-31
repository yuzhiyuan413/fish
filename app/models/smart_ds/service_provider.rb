class SmartDs::ServiceProvider < ActiveRecord::Base
	establish_connection "daily_smart_#{Rails.env}".to_sym
	extend RedisCacheHelper

	SP_CACHE_KEY = 'charge_monitor_sp'
	SP_NAME_ID_MAP = 'analysis_sp_name_id'

	def self.options
		Rails.cache.exist?(SP_CACHE_KEY) ?
			Rails.cache.read(SP_CACHE_KEY) :
				service_providers
	end

	def self.sp_options
		 Rails.cache.exist?(SP_NAME_ID_MAP) ?
			Rails.cache.read(SP_NAME_ID_MAP) :
			  sp
	end


	def self.sp
		sp = select(:id,:name).order(:name).inject({}){|result,i| result.merge({i.id.to_s=>i.name})}.merge({"all" => "全部"})
		Rails.cache.write(SP_NAME_ID_MAP,sp)
		sp
	end

	def self.service_providers
		select(:id,:name).where("name not like ? ","off%").order(:name).collect{|x| [x.name,x.id]}
	end

	def self.refresh_cache
		reset_cache(SP_CACHE_KEY, service_providers)
	end

end
