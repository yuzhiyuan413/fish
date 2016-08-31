# encoding: utf-8
module Charge::AnalysisReportsHelper

	def analysis_code_type_options
		base_item = [["全部码类型",'all'],["码类型明细",0]]
		base_item += SmartDs::CodeBusinessType.options
		options_for_select(base_item)
	end

	def analysis_province_options
		base_item = [["全部省份",'all'],["省份明细",0]]
		base_item +=  PandaDs::Province.options
		options_for_select(base_item)
	end

	def analysis_operator_options
		base_item = [["全部运营商",'all'],["运营商明细",0]]
		base_item +=  PandaDs::Operator.options
		options_for_select(base_item)
	end

	def analysis_city_options
		base_item = PandaDs::City.options
		options = %Q|<option value='all'>全部城市</option><option value=0>城市明细</option>|
		base_item.each do |city|
			options += %Q|<option parent-id = #{city[2]} value= #{city[1]}>#{city[0]}</option>| if !city[0].include?("错误_")
		end
		options.html_safe
	end

	def analysis_service_provider_options
		base_item = [["全部SP渠道",'all'],["SP渠道明细",0]]
		base_item +=  SmartDs::ServiceProvider.options
		options_for_select(base_item)
	end


	def analysis_product_tag_options
		base_item = [["全部标签",'all'],["标签明细",0]]
		base_item += SmartDs::ProductTag.options
		options_for_select(base_item)
	end

end
