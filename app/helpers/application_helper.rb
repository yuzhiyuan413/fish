module ApplicationHelper
  def try_var var
    defined?(var) ? var : nil
  end

  def current_account
  	session[:current_account]
	end

	def treeview_menu_active ctl, act
		"active" if params[:controller].eql?(ctl) and params[:action].eql?(act)
	end

	def treeview_active functions
		functions.any?{|f| f.controller.eql?(params[:controller]) and f.action.eql?(params[:action]) } ? "active" : ""
	end

  def sidebar_menu_cache account_id
		cache_key = "sidebar_#{account_id}"
		Rails.cache.write(cache_key, sidebar_menu(account_id)) if not Rails.cache.exist?(cache_key)
		Rails.cache.read(cache_key)
	end

	def sidebar_menu account_id
		sidebar_items = Pass::System.subsystems.collect{|subsystem|
			next if subsystem.name == "个人信息"
			next if not subsystem.allow?(account_id)
			treeview = OpenStruct.new
			treeview.functions = subsystem.functions
			treeview.name = subsystem.name
			treeview.icon_class = subsystem.icon_class
			treeview.treeview_menu = subsystem.functions.collect{ |function|
				next if function.hidden.to_i == 1
				next if not function.allow?(account_id)
				treeview_menu = OpenStruct.new
				treeview_menu.controller = function.controller
				treeview_menu.action = function.action
				treeview_menu.name = function.name
				treeview_menu.icon_class = function.icon_class
				if function.url.blank?
					treeview_menu.url = url_for(controller: function.controller, action: function.action)
				else
					treeview_menu.url = "#{function.url}/#{function.controller}/#{function.action}"
				end
				treeview_menu
			}.compact
			treeview
		}.compact
		sidebar_items
	end

	def menu_active ctl, act
		"active" if params[:controller].eql?(ctl) and params[:action].eql?(act)
	end

	def dropdown_active functions
		flag = functions.any?{|f| f.controller.eql?(params[:controller]) and f.action.eql?(params[:action]) }
		flag ? "dropdown active" : "dropdown"
	end

	def uri_for options
		tmp = url_options[:_path_segments][:controller]
		url_options[:_path_segments][:controller] = nil
		url = url_for(options)
		url_options[:_path_segments][:controller] = tmp
		url
	end

	def charge_operator_options
		ModelMappings::OPERATOR_NAME_TO_ID.keys
		# options_for_select(ModelMappings::OPERATOR_NAME_TO_ID.keys)
	end

	def charge_provinces_options
		tags = [["全部省份","全部省份"],["其他省份","其他省份"],["北京","北京"],
    ["天津","天津"],["上海","上海"],["重庆","重庆"],["河南","河南"],["河北","河北"],
    ["山西","山西"],["内蒙古","内蒙古"],["辽宁","辽宁"],["吉林","吉林"],
    ["黑龙江","黑龙江"],["江苏","江苏"],["浙江","浙江"],["安徽","安徽"],
    ["福建","福建"],["江西","江西"],["山东","山东"],["湖北","湖北"],["湖南","湖南"],
    ["广东","广东"],["广西","广西"],["海南","海南"],["四川","四川"],["贵州","贵州"],
    ["云南","云南"],["西藏","西藏"],["陕西","陕西"],["甘肃","甘肃"],["青海","青海"],
    ["宁夏","宁夏"],["新疆","新疆"],["香港","香港"],["澳门","澳门"],["台湾","台湾"],
    ["国外","国外"]]
    # options_for_select(tags)

	end

	def tags_options_cache report_class
		System::TagGroup.tags_options_cache(report_class, System::Constant::PICK_OPTIONS[report_class])
	end

	def tags_options report_class
		System::TagGroup.tags_options(report_class, System::Constant::PICK_OPTIONS[report_class])
	end

	def dropdown_items_cache account_id
		cache_key = "dropdown_#{account_id}"
		Rails.cache.write(cache_key, dropdown_items(account_id)) if not Rails.cache.exist?(cache_key)
		Rails.cache.read(cache_key)
	end

	def dropdown_items account_id
		items = []
		dropdown_struct = OpenStruct.new
		dropdown_item_struct = OpenStruct.new([:controller, :action, :name, :url])
		Pass::System.subsystems.each do |subsystem|
			next if subsystem.name == "个人信息"
			next if not subsystem.allow?(account_id)
			dropdown = dropdown_struct.dup
			dropdown.functions = subsystem.functions
			dropdown.name = subsystem.name
			dropdown_list = []
			subsystem.functions.each do |function|
				next if function.hidden.to_i == 1
				next if not function.allow?(account_id)
				dropdown_item = dropdown_item_struct.dup
				dropdown_item.controller = function.controller
				dropdown_item.action = function.action
				dropdown_item.name = function.name
				if function.url.blank?
					dropdown_item.url = uri_for(:action => function.action, :controller => function.controller)
				else
					dropdown_item.url = "#{function.url}/#{function.controller}/#{function.action}"
				end
				dropdown_item.active = "active" if params[:controller].eql?(function.controller) and params[:action].eql?(function.action)
				dropdown_list << dropdown_item
			end
			dropdown.list = dropdown_list
			items << dropdown
		end
		items
	end

  def default_title
    "#{Pass::System.current_function.name}" # Pass::Controller.find_by_name(Pass::System.current_function.controller).description
  end

  def transfer_to_camelcase(model)
  	model.gsub(/\//,'::_').gsub(/([s])$/,'').camelcase.gsub(/Charge::ActivityTrendReport/,'Charge::ActivityReport').constantize
  end

	def manufacturers_options
		 ["全部厂商"] + Seed::PropDetailMonthlyReport.manufacturers
	end

	def boards_options
		 ["全部型号"] + Seed::PropDetailMonthlyReport.boards
	end

	def include_model_js?
    ! %W{system/accounts system/tag_groups system/roles system/logs
      system/permissions system/update_password}.include?(params[:controller])
	end
end
