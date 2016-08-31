# encoding: utf-8
class System::AccountsController < ApplicationController
  before_action :set_system_account, only: [:show, :edit, :update, :destroy]

  def index
    @accounts = System::Account.all
  end

  def show
  end

  def new
    @account = System::Account.new
  end

  def edit
    @account.password_confirmation = @account.password
  end

  def create
    @account = System::Account.new(system_account_params)
    @account.status = 1
    respond_to do |format|
      if @account.save
        format.html { redirect_to system_accounts_url, notice: '添加帐号成功.' }
        format.json { render :show, status: :created, location: @account }
      else
        format.html { render :new }
        format.json { render json: @account.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @account.update(system_account_params)
        format.html { redirect_to system_accounts_url, notice: '更新帐号成功.' }
        format.json { render :index, status: :ok, location: @account }
      else
        format.html { render :edit }
        format.json { render json: @account.errors, status: :unprocessable_entity }
      end
    end
  end


  def destroy
    @account.destroy
    respond_to do |format|
      format.html { redirect_to system_accounts_url, notice: '删除帐号成功.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_system_account
      @account = System::Account.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def system_account_params
      params.require(:system_account).permit(:name, :password, :status, :password_confirmation, role_ids: [] )
    end

end
