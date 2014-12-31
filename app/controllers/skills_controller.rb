class SkillsController < ApplicationController
  before_filter :signed_in_user
  before_action :set_skill, only: [:show, :edit, :update, :destroy]

  # GET /skills
  # GET /skills.json
  def index
    render :partial => 'skills/skills_manage'
  end

  def show_index
    sql = 'true'
    if params[:name] && params[:name] != '' && params[:name] != 'null'
      sql << " and name like '%#{params[:name]}%'"
    end
    count = Skill.where(sql).count
    totalpages = count % params[:rows].to_i == 0 ? count / params[:rows].to_i : count / params[:rows].to_i + 1
    @skills = Skill.where(sql).limit(params[:rows].to_i).offset(params[:rows].to_i*(params[:page].to_i-1))
    render :json => {:skills => @skills.as_json, :totalpages => totalpages, :currpage => params[:page].to_i, :totalrecords => count}
  end

  def get_groups
    @skill = Skill.find(params[:skill_id])
    if @skill && !@skill.groups.nil? && !@skill.groups.empty?
      @groups = @skill.groups
    else
      @groups = Group.all
    end
    count = @groups.count
    totalpages = count % params[:rows].to_i == 0 ? count / params[:rows].to_i : count / params[:rows].to_i + 1
    @skills = @groups.limit(params[:rows].to_i).offset(params[:rows].to_i*(params[:page].to_i-1))
    render :json => {:groups => @groups.as_json, :totalpages => totalpages, :currpage => params[:page].to_i, :totalrecords => count}
  end

  def get_unrelated_groups
    @groups = Group.where(" id not in (select group_id from groups_skills where skill_id = ?)", params[:skill_id])
    render :json => {groups: @groups.as_json}
  end

  def group_list
    @skill = Skill.find(params[:skill_id])
    @groups = Group.where(" id not in (select group_id from groups_skills where skill_id = ?)", @skill.id)
    render :partial => 'skills/group_list'
  end

  def oper_action
    if params[:oper] == 'add'
      create
    elsif params[:oper] == 'del'
      set_skill
      destroy
    elsif params[:oper] == 'edit'
      set_skill
      update
    end
  end

  # GET /skills/1
  # GET /skills/1.json
  def show
  end

  # GET /skills/new
  def new
    @skill = Skill.new
    render :partial => 'skills/add'
  end

  # GET /skills/1/edit
  def edit
    render :partial => 'skills/edit'
  end

  # POST /skills
  # POST /skills.json
  def create
    @skill = Skill.new(skill_params)
    if @skill.save
      render :json => {:success => true}
    else
      render :json=> {:success => false, :errors => '添加失败！'}
    end

    #respond_to do |format|
    #  if @skill.save
    #    format.html { redirect_to @skill, notice: 'Admin was successfully created.' }
    #    format.json { render :show, status: :created, location: @skill }
    #  else
    #    format.html { render :new }
    #    format.json { render json: @skill.errors, status: :unprocessable_entity }
    #  end
    #end
  end

  # PATCH/PUT /skills/1
  # PATCH/PUT /skills/1.json
  def update
    if @skill.photo && (@skill.photo != skill_params[:photo])
      photo_name = @skill.photo[@skill.photo.rindex('/')+1, @skill.photo.length]
      deleteFromAliyun(photo_name, Settings.aliyunOSS.beijing_service, Settings.aliyunOSS.image_bucket)
    end
    if @skill.update(skill_params)
      render :json => {:success => true}
    else
      render :json => {:success => false, :errors => '修改失败！'}
    end
    #respond_to do |format|
    #  if @skill.update(skill_params)
    #    format.html { redirect_to @skill, notice: 'Admin was successfully updated.' }
    #    format.json { render :show, status: :ok, location: @skill }
    #  else
    #    format.html { render :edit }
    #    format.json { render json: @skill.errors, status: :unprocessable_entity }
    #  end
    #end
  end

  # DELETE /skills/1
  # DELETE /skills/1.json
  def destroy
    if @skill.photo && @skill.photo != ''
      photo_name = @skill.photo[@skill.photo.rindex('/')+1, @skill.photo.length]
      deleteFromAliyun(photo_name, Settings.aliyunOSS.beijing_service, Settings.aliyunOSS.image_bucket)
    end
   if @skill.destroy
     render :json => {:success => true}
   end
    #respond_to do |format|
    #  format.html { redirect_to skills_url, notice: 'Admin was successfully destroyed.' }
    #  format.json { head :no_content }
    #end
  end

  def batch_delete
    if params[:ids]
      @skills = Skill.where("id in (#{params[:ids].join(',')})")
      if @skills.delete_all
        render :json => {:success => true}
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_skill
      @skill = Skill.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def skill_params
      params.permit(:id, :name, :photo, :desc, :detail, :period, :from, :create_by_user, :keywords, :sort, :index_page_show)
    end
end
