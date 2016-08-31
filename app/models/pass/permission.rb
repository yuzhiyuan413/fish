class Pass::Permission < Pass::Base

  self.table_name = "permissions"

  serialize :operates, Array

  #添加
  ADD_CODE = "0"
  #查看
  SHOW_CODE = "1"
  #删除
  DELETE_CODE = "2"
  #修改
  EDIT_CODE = "3"

  OPERATE_CODES = [ADD_CODE, SHOW_CODE, DELETE_CODE, EDIT_CODE]

  #状态 允许
  STATUS_YES = 1

  #状态 禁止
  STATUS_NO = 0

  ALLOW = 'allow'

  NOT_ALLOW = 'not allow'

  DO_NOT_KNOW = "do not know"

  def function
    @function ||= Pass::System.functions.find { |f| f.id == function_id }
  end

  def subsystem
    @subsystem ||= Pass::System.subsystems.find { |f| f.id == subsystem_id }
  end

  #是否有权限
  def pass controller, operate
    return DO_NOT_KNOW unless any_controller?(controller)
    return DO_NOT_KNOW unless any_operate?(operate)
    return ALLOW if self.status == STATUS_YES
    return NOT_ALLOW if self.status == STATUS_NO
    return DO_NOT_KNOW
  end

  def all_operate?
    return true if operates.nil? or operates.length == 0
    return true if OPERATE_CODES.all?{ |o| operates.include?(o)}
    return false
  end

  def self.find_all_by_link_type_and_link_id link_type, link_id
    where({link_type: link_type, link_id: link_id}).order("sort")
  end

#这条权限信息是否包含这个操作
  def any_operate? operate
    return false if operate.nil?
    return true if operates.nil? or operates.length == 0
    operates.any? { |o| o.to_i == operate.to_i }
  end

  private

  #这条权限信息是否包含这个controller
  def any_controller? controller
    if subsystem and function
      return function.controllers.any? { |c| c.name == controller }
    elsif subsystem_id == 0 and function_id == 0
      return true
    elsif subsystem and function_id == 0
      return subsystem.functions.any? { |f| f.controllers.any? { |c| c.name == controller }}
    else
      return false
    end
  end

end
