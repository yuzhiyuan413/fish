# encoding: utf-8
module Charge::MonitorReportsHelper

	HOST_FULLNAMES = ["NY-APP-12-10","NY-APP-12-177","NY-APP-12-72",
		"NY-APP-12-74", "NY-APP-12-97","NY-APP-12-98","NY-FW-12-19","NY-FW-12-20"]

	REPORT_HOUR = ["00","01","02","03","04","05","06","07","08","09","10",
		"11","12","13","14","15","16","17","18","19","20","21","22","23"]

	def province_options(all = true)
		base_item = [["全部省份",'0']]
    options = PandaDs::Province.options
    base_item += options
    base_item = all ? base_item : options
		options_for_select(base_item)
	end

	def operator_options
		options_for_select(PandaDs::Operator.options)
	end

	def city_options(all = true)
		cities = PandaDs::City.options
		options = all ? %Q|<option value=0>全部城市</option>| : ''
		cities.each do |city|
			options += %Q|<option parent-id = #{city[2]} value= #{city[1]}>#{city[0]}</option>| if !city[0].include?("错误_")
		end
		options.html_safe
	end

	def service_provider_options
		options_for_select(SmartDs::ServiceProvider.options)
	end

	def host_fullname_options
		options_for_select(HOST_FULLNAMES)
	end

	def report_hour_options
		options_for_select(REPORT_HOUR)
	end

end
