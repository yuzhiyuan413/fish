# -*- encoding : utf-8 -*-
module ChargeHelper
  def charge_tags_options report_class
		cache_key = "#{report_class.to_s}::tags"
		Rails.cache.write(cache_key, (["全部组选"] + report_class.tags)) if not Rails.cache.exist?(cache_key)
		Rails.cache.read(cache_key)
  end

	def charge_product_versions_options report_class
		cache_key = "#{report_class.to_s}::product_versions"
		Rails.cache.write(cache_key, report_class.product_versions) if not Rails.cache.exist?(cache_key)
		Rails.cache.read(cache_key)
	end

  def reset_charge_options_cache report_class
		tags_cache_key = "#{report_class.to_s}::tags"
		product_versions_cache_key = "#{report_class.to_s}::product_versions"
		Rails.cache.delete(tags_cache_key) if Rails.cache.exist?(tags_cache_key)
		Rails.cache.delete(product_versions_cache_key) if Rails.cache.exist?(product_versions_cache_key)
		Rails.cache.write(tags_cache_key, (["全部组选"] + report_class.tags))
		Rails.cache.write(product_versions_cache_key, report_class.product_versions)
  end

	def charge_product_versions_group product_versions = []
		version = product_versions.shift
		items = product_versions.group_by{|item| item.split(".")[0]}
		[].tap do |x|
			items.each {|k,v| x << ["#{k}版本汇总",v]}
			x.unshift([version,[version]]).compact!
		end
	end

end
