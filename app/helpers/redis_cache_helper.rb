module RedisCacheHelper
  def drop_dropdown_items_cache
		Rails.cache.delete_matched("dropdown_*")
	end

  def reset_cache key, value
    Rails.cache.delete(key) if Rails.cache.exist?(key)
		Rails.cache.write(key, value)
  end
end
