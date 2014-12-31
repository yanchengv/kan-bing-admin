class DoctorsGroupsController < ApplicationController
  before_filter :signed_in_user
  before_action :set_doctors_group, only: [:show, :edit, :update, :destroy]

  # GET /doctors_groups
  # GET /doctors_groups.json
  def index
  end

  # GET /doctors_groups/1
  # GET /doctors_groups/1.json
  def show
  end

  # GET /doctors_groups/new
  def new
    @doctors_group = DoctorsGroup.new
  end

  # GET /doctors_groups/1/edit
  def edit
  end

  # POST /doctors_groups
  # POST /doctors_groups.json
  def create
    @doctors_group = DoctorsGroup.new(doctors_group_params)
    if @doctors_group.save
      render :json => {:success => true}
    else
      render :json=> {:success => false, :errors => '添加失败！'}
    end
  end

  # PATCH/PUT /doctors_groups/1
  # PATCH/PUT /doctors_groups/1.json
  def update
    if @doctors_group.update(doctors_group_params)
      render :json => {:success => true}
    else
      render :json => {:success => false, :errors => '修改失败！'}
    end
  end
  #删除关联关系
  def del_doctor_group
    if params[:group_id] && params[:doctor_id]
      if DoctorsGroup.where(:group_id => params[:group_id], :doctor_id => params[:doctor_id]).delete_all
        render :json => {success: true}
      else
        render :json => {success: false}
      end
    else
      render :json => {success: false}
    end
  end

  # DELETE /doctors_groups/1
  # DELETE /doctors_groups/1.json
  def destroy
    if @doctors_group.destroy
      render :json => {:success => true}
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_doctors_group
      @doctors_group = DoctorsGroup.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def doctors_group_params
      params.permit(:group_id, :doctor_id)
    end
end
