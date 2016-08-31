# encoding: utf-8
class System::RolesController < ApplicationController
  before_action :set_system_role, only: [:show, :edit, :update, :destroy]
  # GET /roles
  # GET /roles.xml
  def index
    @roles = System::Role.all
  end

  # GET /roles/1
  # GET /roles/1.xml
  def show
  end

  # GET /roles/new
  # GET /roles/new.xml
  def new
    @role = System::Role.new
  end

  # GET /roles/1/edit
  def edit
  end

  # POST /roles
  # POST /roles.xml
  def create
    @role = System::Role.new(system_role_params)
    respond_to do |format|
      if @role.save
        format.html { redirect_to system_roles_url, notice: '添加角色成功.' }
        format.json { render :show, status: :created, location: @role }
      else
        format.html { render :new }
        format.json { render json: @role.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /roles/1
  # PUT /roles/1.xml
  def update
    respond_to do |format|
      if @role.update(system_role_params)
        format.html { redirect_to system_roles_url, notice: '更新角色成功.' }
        format.json { render :index, status: :ok, location: @role }
      else
        format.html { render :edit }
        format.json { render json: @role.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /roles/1
  # DELETE /roles/1.xml
  def destroy
    @role.destroy
    respond_to do |format|
      format.html { redirect_to system_roles_url, notice: '删除角色成功.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_system_role
      @role = System::Role.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def system_role_params
      params.require(:system_role).permit(:name, :description)
    end

end
