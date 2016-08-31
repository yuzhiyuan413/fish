# ActionController::Flash::FlashHash = ActionDispatch::Flash::FlashHash

# cas_logger = CASClient::Logger.new("#{Rails.root}/log/cas.log")
# cas_logger.level = Logger::DEBUG
if Rails.env == 'production'
  CASClient::Frameworks::Rails::Filter.configure(
    :enable_cas => true,
    :cas_base_url  => "https://cas.appleflying.com:8443/cas-server-webapp/", # 认证服务器的地址
    # :service_url => "http://www.smart-kangaroo.com",  #登录成功后返回的地址（可选， 默认是从哪来回哪去）
    # :username_session_key => :cas_user, #在session中记录用户名的key（可选）
    # :extra_attributes_session_key => :cas_extra_attributes, #在session中记录附加字段的key（可选）
    # :logger => cas_logger,#日志配置（可选）
    :ticket_store => :active_record_ticket_store,
    :enable_single_sign_out => true #单点登出（可选）
  )
else
  CASClient::Frameworks::Rails::Filter.configure(
    :enable_cas => false,
    :cas_base_url  => "https://cas.appleflying.com:8443/cas-server-webapp/", # 认证服务器的地址
    # :service_url => "http://www.smart-kangaroo.com",  #登录成功后返回的地址（可选， 默认是从哪来回哪去）
    # :username_session_key => :cas_user, #在session中记录用户名的key（可选）
    # :extra_attributes_session_key => :cas_extra_attributes, #在session中记录附加字段的key（可选）
    # :logger => cas_logger,#日志配置（可选）
    :ticket_store => :active_record_ticket_store,
    :enable_single_sign_out => true #单点登出（可选）
  )
end
