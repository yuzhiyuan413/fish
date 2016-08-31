# encoding: utf-8
class Pass::Subsystem

  attr_accessor :id, :name, :functions, :icon_class

  def initialize
    @functions = []
  end

  def attributes attr
    raise ArgumentError, "已存在相同subsystem:#{attr[:id]}" if Pass::System.subsystems.any? { |s| s.id.to_i == attr[:id].to_i }
    @id = attr[:id]
    @description = attr[:name]
    @icon_class = attr[:icon_class]
  end

  def define_function name
    raise ArgumentError, "已存在相同function:#{name}" if Pass::System.functions.any? { |f| f.name == name }
    f = Pass::Function.new
    f.name = name
    f.subsystem = self
    yield(f)
    @functions << f
    Pass::System.functions << f
    f
  end

  def allow? account_id
    functions.any? { |f| f.allow? account_id }
  end

end
