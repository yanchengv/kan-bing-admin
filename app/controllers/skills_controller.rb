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

  def get_unrelated_doctors
    sql = 'true'
    if !current_user.nil?
      if current_user.admin_type == '医院管理员'
        if !current_user.hospital_id.nil? && !current_user.hospital_id != ''
          sql << " and hospital_id = #{current_user.hospital_id}"
        end
      elsif current_user.admin_type == '科室管理员'
        if !current_user.department_id.nil? && !current_user.department_id != ''
          sql << " and department_id = #{current_user.department_id}"
        end
      end
    end
    if params[:province_id] && params[:province_id] != '' && params[:province_id] != 'all' && params[:province_id] != 'null'
      sql << " and province_id = #{params[:province_id]}"
    end
    if params[:city_id] && params[:city_id] != '' && params[:city_id] != 'all' && params[:city_id] != 'null'
      sql << " and city_id = #{params[:city_id]}"
    end
    if params[:hospital_id] && params[:hospital_id] != '' && params[:hospital_id] != 'all' && params[:hospital_id] != 'null'
      sql << " and hospital_id = #{params[:hospital_id]}"
    end
    if params[:department_id] && params[:department_id] != '' && params[:department_id] != 'all' && params[:department_id] != 'null'
      sql << " and department_id = #{params[:department_id]}"
    end
    if params[:name] && params[:name] != '' && params[:name] != 'null'
      sql << " and name like '%#{params[:name]}%' "
    end
    @skill = Skill.find(params[:skill_id])
    if @skill
      sql << " and id not in (select doctor_id from doctors_skills where skill_id = #{params[:skill_id]})"
    end
    @doctors = Doctor.where(sql)
    count = @doctors.count
    totalpages = count % params[:rows].to_i == 0 ? count / params[:rows].to_i : count / params[:rows].to_i + 1
    @doctors = Doctor.where(sql).limit(params[:rows].to_i).offset(params[:rows].to_i*(params[:page].to_i-1))
    render :json => {:doctors => @doctors.as_json, :totalpages => totalpages, :currpage => params[:page].to_i, :totalrecords => count}
  end

  def group_list
    @skill = Skill.find(params[:skill_id])
    @groups = Group.where(" id not in (select group_id from groups_skills where skill_id = ?)", @skill.id)
    render :partial => 'skills/group_list'
  end

  def doctor_list
    @skill = Skill.find(params[:skill_id])
    @provinces = Province.select(:id, :name).all
    @cities = City.select(:id, :name).all
    @hospitals = Hospital.select(:id, :name).all
    @departments = Department.select(:id, :name).all
    render :partial => 'skills/docs_list'
  end

  def get_doctors
    @skill = Skill.find(params[:skill_id])
    @doctors = @skill.doctors
    count = @doctors.count
    totalpages = count % params[:rows].to_i == 0 ? count / params[:rows].to_i : count / params[:rows].to_i + 1
    @doctors = @doctors.limit(params[:rows].to_i).offset(params[:rows].to_i*(params[:page].to_i-1))
    render :json => {:doctors => @doctors.as_json, :totalpages => totalpages, :currpage => params[:page].to_i, :totalrecords => count}
  end

  def save_doctors
    @skill = Skill.find(params[:skill_id])
    @doctors = Doctor.where(" id in (#{params[:doctor_ids].join(',')})")
    @skill.doctors << @doctors
    render :json => {:success => true}
  end

  def add_skill_group
    if params[:skill_id] && params[:group_id]
      @skill = Skill.find(params[:skill_id])
      @skill.groups << Group.find(params[:group_id]) if @skill
      render :json => {success: true}
    else
      render :json => {success: false}
    end

  end

  def del_group_skill
    if params[:group_id] && params[:skill_id]
      if GroupsSkill.where(:group_id => params[:group_id], :skill_id => params[:skill_id]).delete_all
        render :json => {success: true}
      else
        render :json => {success: false}
      end
    else
      render :json => {success: false}
    end
  end

  def del_doctor_skill
    if params[:doctor_id] && params[:skill_id]
      if DoctorsSkill.where(:doctor_id => params[:doctor_id], :skill_id => params[:skill_id]).delete_all
        render :json => {success: true}
      else
        render :json => {success: false}
      end
    else
      render :json => {success: false}
    end
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
