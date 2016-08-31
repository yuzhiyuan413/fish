# encoding: utf-8
class System::PermissionsController < ApplicationController
  include System::PermissionsHelper
  before_action :set_system_permission, only: [:edit, :update]

  def get_functions
    render :json => functions(params[:subsystem_id])
  end

  def index
    @permissions = System::Permission.find_all_by_link_type_and_link_id(
      params[:link_type], params[:link_id])
  end

  def new
    @permission = System::Permission.new
    @permission.link_type = params[:link_type]
    @permission.link_id = params[:link_id]
  end

  def edit
  end

  def update
    if @permission.update_attributes(system_permission_params)
      flash[:notice] = '编辑权限成功.'
      redirect_to :action => :index, :link_type => @permission.link_type, :link_id => @permission.link_id
    else
      render :action => :edit
    end
  end

  def create
    @permission = System::Permission.new(system_permission_params)
    if @permission.save
      flash[:notice] = '添加权限成功.'
      redirect_to :action => :index, :link_type => @permission.link_type, :link_id => @permission.link_id
    else
      render :action => :new
    end
  end

  def destroy
    permission = System::Permission.find(params[:id])
    permission.destroy
    redirect_to :action => :index, :link_type => permission.link_type, :link_id => permission.link_id
  end

  def sort
    permission = System::Permission.update_sort params[:m], params[:n]
    redirect_to :action => :index, :link_type => permission.link_type, :link_id => permission.link_id
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_system_permission
      @permission = System::Permission.find(params[:id])
    end

    def system_permission_params
      params.require(:system_permission).permit(:sort, :link_type, :link_id,
        :subsystem_id, :function_id, :status, operates: [])
    end

end
