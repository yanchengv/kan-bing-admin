class GroupsSkillsController < ApplicationController
  before_filter :signed_in_user
  before_action :set_groups_skill, only: [:show, :edit, :update, :destroy]

  # GET /groups_skills
  # GET /groups_skills.json
  def index
    render :partial => 'groups_skills/groups_skills_manage'
  end

  def show_index
    count = GroupsSkill.all
    totalpages = count % params[:rows].to_i == 0 ? count / params[:rows].to_i : count / params[:rows].to_i + 1
    @groups_skills = GroupsSkill.all.limit(params[:rows].to_i).offset(params[:rows].to_i*(params[:page].to_i-1))
    render :json => {:groups_skills => @groups_skills.as_json, :totalpages => totalpages, :currpage => params[:page].to_i, :totalrecords => count}
  end

  def oper_action
    if params[:oper] == 'add'
      create
    elsif params[:oper] == 'del'
      set_groups_skill
      destroy
    elsif params[:oper] == 'edit'
      set_groups_skill
      update
    end
  end

  # GET /groups_skills/1
  # GET /groups_skills/1.json
  def show
  end

  # GET /groups_skills/new
  def new
    @groups_skill = GroupsSkill.new
    render :partial => 'groups_skills/add'
  end

  # GET /groups_skills/1/edit
  def edit
    render :partial => 'groups_skills/edit'
  end

  # POST /groups_skills
  # POST /groups_skills.json
  def create
    @groups_skill = GroupsSkill.new(groups_skill_params)
    if @groups_skill.save
      render :json => {:success => true}
    else
      render :json=> {:success => false, :errors => '添加失败！'}
    end
  end

  # PATCH/PUT /groups_skills/1
  # PATCH/PUT /groups_skills/1.json
  def update
    if @groups_skill.update(groups_skill_params)
      render :json => {:success => true}
    else
      render :json => {:success => false, :errors => '修改失败！'}
    end
  end

  # DELETE /groups_skills/1
  # DELETE /groups_skills/1.json
  def destroy
    if @groups_skill.destroy
      render :json => {:success => true}
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_groups_skill
      @groups_skill = GroupsSkill.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def groups_skill_params
      params.permit(:group_id, :skill_id)
    end
end
