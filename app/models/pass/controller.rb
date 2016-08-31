# encoding: utf-8
class Pass::Controller

  MAIN = 'main'

  attr_accessor :name, :description, :function_id, :function

  def initialize attr
    raise ArgumentError, "已存在相同Controller:#{attr[:name]}" if Pass::System.controllers.any? { |c| c.name == attr[:name] }
    @name = attr[:name]
    @description = attr[:description]
    @function_id = attr[:function_id]
  end

  def allow? account_id, operate
    account = Pass::Account.find account_id
    result = account.allow? name, operate
    return true if result
    account.roles.each do |role|
      result = role.allow? name, operate
      return true if result
    end
    return false
  end

  def self.find_by_name controller_name
    Pass::System.controllers.find { |c| c.name == controller_name }
  end

end
