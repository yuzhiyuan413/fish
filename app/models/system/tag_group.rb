# -*- encoding : utf-8 -*-
class System::TagGroup < ActiveRecord::Base
  establish_connection Rails.env.to_sym
  attr_accessible :desc, :is_sum_group, :name, :regexp
  validates :name, :presence => {:message => '不能为空'}
  validates :regexp, :presence => {:message => '不能为空'}
  validates :desc, :presence => {:message => '不能为空'}

  SUM_TAG_POSTFIX = '汇总'
  SUM_GROUP_NAME = '汇总标签'
  MULTI_OPTION_TAG_POSTFIX = '组选'
  MULTI_OPTION_GROUP_NAME = '组选标签'
  UNKNOWN_TAG = '未分组标签'
  TOTAL_SUM_TAG = '全部汇总'
  TOTAL_CHARGE_SUM_TAG = '全部标签'
  TOTAL_OPTION_TAG = '全部组选'
  PARTNER_GROUP_NAME = '渠道组选'

  def is_sum_group_text
    ModelMappings::BOOL_TO_CN[self.is_sum_group]
  end

  class << self
    def distribute_tags tags
      grouped_tags = {}
      all.each do |tag_group|
        grouped_tags[tag_group.name] = tags.select{|tag| tag =~ Regexp.new(tag_group.regexp)}
      end
      unknown_tags = tags - (grouped_tags.values.inject(&:|) || [])
      grouped_tags[UNKNOWN_TAG] = unknown_tags.select{|tag| !tag.end_with? SUM_TAG_POSTFIX}
      grouped_tags
    end

    def distribute names
      sum_group_tags = sum_groups.collect do |group|
        group_names = names.select{|name| name =~ Regexp.new(group.regexp)}
        ["#{group.name}#{SUM_TAG_POSTFIX}", group_names].flatten unless group_names.blank?
      end
      sum_group_tags.unshift([TOTAL_SUM_TAG,nil]).compact
    end

    def tag_adaptor report_class, tag
      if tag.end_with?(MULTI_OPTION_TAG_POSTFIX)
        tags_options = tags_options_cache(report_class, System::Constant::PICK_OPTIONS[report_class])
        tags_options.each do |options|
          return options[1] if tag == "#{options.first}#{MULTI_OPTION_TAG_POSTFIX}"
        end
      else
        tag
      end
    end

    def tags_options_cache report_class, pick_options=[]
  		cache = Rails.cache
  		if cache.exist?(report_class.to_s)
  			cache.read(report_class.to_s)
  		else
  			options = tags_options(report_class, pick_options)
  			cache.write(report_class.to_s, options)
  			options
  		end
  	end

    def reset_tags_options_cache report_class, pick_options=[]
  		cache = Rails.cache
  		cache.delete(report_class.to_s) if cache.exist?(report_class.to_s)
  		cache.write(report_class.to_s, tags_options(report_class, pick_options))
  	end

  	def tags_options report_class, pick_options=[]
  		options = []
      type = :charge unless report_class.to_s["Charge::"].nil?
  		options << sum_tags_group(type) if pick_options.include?(:sum_tags)
  		options << multi_option_tags_group if pick_options.include?(:multi_option_tags)
  		options << [PARTNER_GROUP_NAME, Seed::ActivationReport.partners] if pick_options.include?(:partner_tags)
  		options += distribute_tags(report_class.tags).to_a
  	end

    private
      def sum_groups
        where({:is_sum_group => true})
      end

      def sum_tags_group type = nil
        [ SUM_GROUP_NAME, type.nil? ? sum_tag_names.unshift(TOTAL_SUM_TAG) : sum_tag_names.unshift(TOTAL_CHARGE_SUM_TAG) ]
      end

      def multi_option_tags_group
        [ MULTI_OPTION_GROUP_NAME, multi_option_tag_names.unshift(TOTAL_OPTION_TAG)]
      end

      def sum_tag_names
        select(:name).where({:is_sum_group => true}).collect{ |record|
          "#{record.name}#{SUM_TAG_POSTFIX}" if record.name.present?
        }.compact
      end

      def multi_option_tag_names
        select(:name).collect{ |record|
          "#{record.name}#{MULTI_OPTION_TAG_POSTFIX}" if record.name.present?
        }.compact
      end
  end

end
