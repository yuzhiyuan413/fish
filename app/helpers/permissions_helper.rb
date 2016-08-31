# -*- encoding : utf-8 -*-
module PermissionsHelper

  def object_page_link
    if params[:link_type] == "Account"
      link = link_to("帐号管理","#{url_for(:controller => 'accounts')}?link_type=#{params[:link_type]}&link_id=#{params[:link_id]}")
    elsif params[:link_type] == "Role"
      link = link_to("角色管理","#{url_for(:controller => 'roles')}?link_type=#{params[:link_type]}&link_id=#{params[:link_id]}")
    end
    return link
  end

  def subsystems
    default_option + Pass::System.subsystems.collect {|p| [ p.name, p.id ] }
  end

  def all_functions
    function_items = Array.new
    function_items << [['无效', nil]]
    function_items << Pass::System.functions.collect {|p| [ p.name, p.id ] }
    function_items + Pass::System.subsystems.collect{|sub_sys| sub_sys.functions.collect {|p| [ p.name, p.id ] } }
  end

  def functions subsystem_id
    return default_option if subsystem_id.blank?
    subsystem = Pass::System.subsystems.find {|s| s.id.to_i == subsystem_id.to_i}
    return default_option if subsystem.blank?
    default_option + subsystem.functions.collect {|p| [ p.name, p.id ] }
  end

  def default_option
    [['无效', nil], ['全部', 0]]
  end

  def subsystem_name permission
    if permission.subsystem
      permission.subsystem.name
    elsif permission.subsystem_id == 0
      '全部'
    else
      '无效'
    end
  end

  def function_name permission
    if permission.function
      permission.function.name
    elsif permission.function_id == 0
      '全部'
    else
      '无效'
    end
  end

end
