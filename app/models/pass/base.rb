# encoding: utf-8
class Pass::Base < ActiveRecord::Base

  DEVELOPMENT = "development"

  PRODUCTION = "production"

  TEST = "test"

  self.abstract_class = true

  def self.init_config
    return nil if ENV["RAILS_ENV"].nil? or ENV["RAILS_ENV"] == ''
    path = "#{Rails.root}/config/database.yml"
    env = "tiger_pass_#{ENV["RAILS_ENV"]}"
    dbconfig = YAML::load(File.open(path))
    cfg = dbconfig[env]
    raise(Pass::ApplicationError, "没用找到配置, 文件路径:#{path}, 环境:#{env}") if cfg.nil?
    establish_connection dbconfig["tiger_pass_#{ENV["RAILS_ENV"]}"]
  end

  init_config

end
