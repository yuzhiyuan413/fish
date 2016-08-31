class SmartDs::CodeBusinessType < ActiveRecord::Base
  establish_connection "daily_smart_#{Rails.env}".to_sym
  extend RedisCacheHelper

  CACHE_KEY = 'code_business_type_options'
  MAP_CACHE_KEY = 'code_business_type_map'

  def self.options
    Rails.cache.exist?(CACHE_KEY) ?
      Rails.cache.read(CACHE_KEY) :
        code_business_type_options
  end

  def self.map
     Rails.cache.exist?(MAP_CACHE_KEY) ?
      Rails.cache.read(MAP_CACHE_KEY) :
        code_business_type_key_map
  end


  def self.code_business_type_key_map
    {}.tap do |x|
      options.each do |o|
        x[o[1].to_s] = o[0]
      end
      x["all"] = "全部"
    end
  end

  def self.code_business_type_options
    select(:coding,:name).order(:name).collect{|x| [x.name, x.coding]}
  end

  def self.refresh_cache
    reset_cache(CACHE_KEY, code_business_type_options)
    reset_cache(MAP_CACHE_KEY, code_business_type_key_map)
  end
end
