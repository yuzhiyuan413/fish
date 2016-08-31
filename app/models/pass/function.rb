# encoding: utf-8
class Pass::Function

  attr_accessor :id, :name, :controller, :action, :url, :hidden, :controllers, :subsystem, :selected, :icon_class

  def initialize
    @controllers = []
  end

  def attributes attr
    raise ArgumentError, "Function的id不能为空" if attr[:id].to_i == 0
    raise ArgumentError, "已存在相同Function:#{attr[:id]}" if Pass::System.functions.any? { |f| f.id.to_i == attr[:id].to_i}
    @id = attr[:id]
    @controller = attr[:controller]
    @action = attr[:action]
    @url = attr[:url]
    @hidden = attr[:hidden]
    @icon_class = attr[:icon_class]
  end

  def define_controller attr
    c = Pass::Controller.new attr
    c.function = self
    @controllers << c
    Pass::System.controllers << c
    c
  end

  def allow? account_id
    controllers.any? { |c| c.allow? account_id, Pass::Permission::SHOW_CODE }
  end

end
