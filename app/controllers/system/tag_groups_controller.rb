class System::TagGroupsController < ApplicationController
  # GET /system/tag_groups
  # GET /system/tag_groups.json
  def index
    @system_tag_groups = System::TagGroup.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @system_tag_groups }
    end
  end

  # GET /system/tag_groups/1
  # GET /system/tag_groups/1.json
  def show
    @system_tag_group = System::TagGroup.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @system_tag_group }
    end
  end

  # GET /system/tag_groups/new
  # GET /system/tag_groups/new.json
  def new
    @system_tag_group = System::TagGroup.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @system_tag_group }
    end
  end

  # GET /system/tag_groups/1/edit
  def edit
    @system_tag_group = System::TagGroup.find(params[:id])
  end

  # POST /system/tag_groups
  # POST /system/tag_groups.json
  def create
    @system_tag_group = System::TagGroup.new(params[:system_tag_group])

    respond_to do |format|
      if @system_tag_group.save
        flash[:notice] = '标签组已保存。'
        format.html { redirect_to :action => "index"}
        format.json { render :json => @system_tag_group, :status => :created, :location => @system_tag_group }
      else
        format.html { render :action => "new" }
        format.json { render :json => @system_tag_group.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /system/tag_groups/1
  # PUT /system/tag_groups/1.json
  def update
    @system_tag_group = System::TagGroup.find(params[:id])

    respond_to do |format|
      if @system_tag_group.update_attributes(params[:system_tag_group])
        flash[:notice] = '标签组已保存。'
        format.html { redirect_to :action => "index"}
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @system_tag_group.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /system/tag_groups/1
  # DELETE /system/tag_groups/1.json
  def destroy
    @system_tag_group = System::TagGroup.find(params[:id])
    @system_tag_group.destroy

    respond_to do |format|
      format.html { redirect_to system_tag_groups_url }
      format.json { head :no_content }
    end
  end
end
