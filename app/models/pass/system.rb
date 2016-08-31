# encoding: utf-8

class Pass::System

  cattr_accessor :root_id

  def self.define_subsystem name
    raise ArgumentError, "已存在相同subsystem:#{name}" if subsystems.any? { |s| s.name == name}
    s = Pass::Subsystem.new
    s.name = name
    yield(s)
    subsystems << s
    s
  end

  def self.reload
    Pass::System.clear
    load "#{Rails.root.to_s}/config/initializers/functions.rb"
  end

  def self.clear
    subsystems.clear
    functions.clear
    controllers.clear
  end

  def self.subsystems
    @subsystems ||= []
  end

  def self.functions
    @functions ||= []
  end

  def self.controllers
    @controllers ||= []
  end

  def self.current_function
    return nil if Pass::ActionInfo.current.nil?
    controller = controllers.find { |c| c.name == Pass::ActionInfo.current.controller }
    return nil if controller.nil?
    return controller.function
  end

end
