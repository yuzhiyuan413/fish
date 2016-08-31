# encoding: utf-8
class System::LoginController < ApplicationController
  before_action :check_login_params, only: [:do_login]

  def index
    if current_account_id && System::Account.exists?(current_account_id)
      login_require(current_account)
    else
      render layout: "login"
    end
  end

  def do_login
    @account = System::Account.check_account(params[:name], params[:password])
    if @account.is_a?(String)
      flash[:warning] = @account
      render action: :index, layout: "login"
    else
      self.current_account = @account
      login_require(@account)
    end
  end

  def login_require account
    root_func = account.available_functions.first
    if root_func
      redirect_to controller: root_func.controller, action: root_func.action
    else
      permission_error
    end
  end

  def timeout
    render layout: "login"
  end

  def logout
    reset_session
    render action: :index, layout: "login"
  end

  def permission_error
    flash[:warning] = "没有权限, 请联系管理员."
    render action: :index, layout: "login"
  end

  def heartbeat
    render :text => System::Heartbeat.report
  end

  private
    def secure?
      false
    end

    def check_login_params
      if params[:name].blank? or params[:password].blank?
        flash[:warning] = "用户名，密码不能为空!"
        render action: :index, layout: "login"
      end
    end

end
