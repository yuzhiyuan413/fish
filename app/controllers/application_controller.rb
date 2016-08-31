class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session
  skip_before_action :verify_authenticity_token
  include Pass::ControllerHelper
  around_action :permission_filter

  protected

  def logout_request?
    CASClient::Request.logout_request?(request)
  end

  def sso_filter
    CASClient::Frameworks::Rails::Filter.filter(self)
  end

  def gateway_filter
    CASClient::Frameworks::Rails::GatewayFilter.filter(self)
  end

  def store_account_id_login
    if session[:account_id_login].blank? && session[:cas_extra_attributes].present?
      session[:account_id_login] = session[:cas_extra_attributes][:id]
    end
  end

  def current_account
    @current_account ||= System::Account.find current_account_id
  end

  def current_account= account
    logger.info "新用户登录:#{account.inspect}"
    session[:account_id_login] = account.id
    session[:current_account] = account
  end
end
