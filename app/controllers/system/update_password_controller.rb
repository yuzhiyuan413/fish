# encoding: utf-8
class System::UpdatePasswordController < ApplicationController

  def edit_password
    @account = current_account
    @account.password_confirmation = @account.password
  end

  def update_password
    @account = current_account
    if @account.update_password(params[:account])
      flash[:notice] = '修改帐号成功.'
      redirect_to(:action => 'index')
    else
      render :action => "edit_password"
    end
  end

  private
    def secure?
      false
    end

end
