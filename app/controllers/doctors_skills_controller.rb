class DoctorsSkillsController < ApplicationController
  before_filter :signed_in_user
  before_action :set_doctors_skill, only: [:show, :edit, :update, :destroy]

  # GET /doctors_skills
  # GET /doctors_skills.json
  def index
  end

  # GET /doctors_skills/1
  # GET /doctors_skills/1.json
  def show
  end

  # GET /doctors_skills/new
  def new
    @doctors_skill = DoctorsSkill.new
  end

  # GET /doctors_skills/1/edit
  def edit
  end

  # POST /doctors_skills
  # POST /doctors_skills.json
  def create
    @doctors_skill = DoctorsSkill.new(doctors_skill_params)
    if @doctors_skill.save
      render :json => {:success => true}
    else
      render :json=> {:success => false, :errors => '添加失败！'}
    end
  end

  # PATCH/PUT /doctors_skills/1
  # PATCH/PUT /doctors_skills/1.json
  def update
    if @doctors_skill.update(doctors_skill_params)
      render :json => {:success => true}
    else
      render :json => {:success => false, :errors => '修改失败！'}
    end
  end
  #删除关联关系
  def del_doctor_skill
    if params[:skill_id] && params[:doctor_id]
      if DoctorsSkill.where(:skill_id => params[:skill_id], :doctor_id => params[:doctor_id]).delete_all
        render :json => {success: true}
      else
        render :json => {success: false}
      end
    else
      render :json => {success: false}
    end
  end

  # DELETE /doctors_skills/1
  # DELETE /doctors_skills/1.json
  def destroy
    if @doctors_skill.destroy
      render :json => {:success => true}
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_doctors_skill
      @doctors_skill = DoctorsSkill.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def doctors_skill_params
      params.permit(:doctor_id, :skill_id)
    end
end
