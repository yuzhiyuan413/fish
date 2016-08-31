class SmartDs::ProductTag < ActiveRecord::Base
	establish_connection "daily_smart_#{Rails.env}".to_sym
	extend RedisCacheHelper
	belongs_to :partner
	TAG_CACHE_KEY = 'charge_analysis_tag'
	SEED_LOST_TAG_CACHE_KEY = 'seed_lost_tag'

	def self.options
		Rails.cache.exist?(TAG_CACHE_KEY) ?
			Rails.cache.read(TAG_CACHE_KEY) :
				product_tags
	end

	def self.seed_lost_options
		Rails.cache.exist?(SEED_LOST_TAG_CACHE_KEY) ?
			Rails.cache.read(SEED_LOST_TAG_CACHE_KEY) :
				seed_lost_product_tags
	end

	def self.product_tags
		select(:tag).order(:tag).collect{|x| [x.tag,x.tag]}
	end

	def self.seed_lost_product_tags
		select(:tag).order(:tag).collect{|x| x.tag}.unshift("全部标签")
	end

	def self.refresh_cache
		reset_cache(TAG_CACHE_KEY, product_tags)
		reset_cache(SEED_LOST_TAG_CACHE_KEY, seed_lost_product_tags)
	end

end
