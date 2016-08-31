# encoding: utf-8
module Pass::ControllerHelper

  protected

  def check_debug_mode
    Pass::System.reload if Rails.env.eql? 'development' and Pass::System.controllers.blank?
  end

  def show?
    return true if secure? == false or params[:controller] == 'login'
    controller = Pass::Controller.find_by_name params[:controller]
    return controller.allow? current_account_id, Pass::Permission::SHOW_CODE
  end

  def secure?
    true
  end

  def permission_filter
    check_debug_mode
    begin
      return if login_required == false
      record_action_info
      raise(Pass::SecurityError,"没有这个权限") if show? == false
      yield
    rescue Pass::SecurityError
      flash[:error_msg] = "没有权限"
      if $base_url
        redirect_to("#{$base_url}/system/login/permission_error")
      else
        redirect_to(:controller => 'system/login',:action => 'permission_error')
      end
    ensure
      Pass::ActionInfo.destroy
    end
  end

  def current_account_id
    return session[:account_id_login]
  end

  #记录请求动作信息
  def record_action_info
    Pass::ActionInfo.new request, params, current_account_id, secure?
  end

  #是否登陆
  def login_required
    if secure? and current_account_id.nil?
      session["return_to"] = request.original_url
      if $base_url
        redirect_to("#{$base_url}/system/login/timeout")
      else
        redirect_to :controller => "system/login", :action => "timeout"
      end
      return false
    end
    return true
  end

end
