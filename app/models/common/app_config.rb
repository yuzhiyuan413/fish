class Common::AppConfig
  include Singleton
   
  def initialize(path = nil)
    path = path.nil? ? "/config/config.yml" : path
    url = Rails.root.to_s + path
    @app_config = YAML.load_file(url)[Rails.env]
  end
  
  def [](key)
    return @app_config[key.to_s]
  end 
end