class GroupsController < ApplicationController
  before_filter :signed_in_user
  before_action :set_group, only: [:show, :edit, :update, :destroy]

  # GET /groups
  # GET /groups.json
  def index
    render :partial => 'groups/groups_manage'
  end

  def show_index
    sql = 'true'
    if params[:name] && params[:name] != '' && params[:name] != 'null'
      sql << " and name like '%#{params[:name]}%'"
    end
    count = Group.where(sql).count
    totalpages = count % params[:rows].to_i == 0 ? count / params[:rows].to_i : count / params[:rows].to_i + 1
    @groups = Group.where(sql).limit(params[:rows].to_i).offset(params[:rows].to_i*(params[:page].to_i-1))
    render :json => {:groups => @groups.as_json, :totalpages => totalpages, :currpage => params[:page].to_i, :totalrecords => count}
  end

  def doctor_list
    @group = Group.find(params[:group_id])
    @provinces = Province.select(:id, :name).all
    @cities = City.select(:id, :name).all
    @hospitals = Hospital.select(:id, :name).all
    @departments = Department.select(:id, :name).all
    render :partial => 'groups/docs_list'
  end

  def get_doctors
    @group = Group.find(params[:group_id])
    @doctors = @group.doctors
    count = @doctors.count
    totalpages = count % params[:rows].to_i == 0 ? count / params[:rows].to_i : count / params[:rows].to_i + 1
    @doctors = @doctors.limit(params[:rows].to_i).offset(params[:rows].to_i*(params[:page].to_i-1))
    render :json => {:doctors => @doctors.as_json, :totalpages => totalpages, :currpage => params[:page].to_i, :totalrecords => count}
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
    @group = Group.find(params[:group_id])
    if @group
      sql << " and id not in (select doctor_id from doctors_groups where group_id = #{params[:group_id]})"
    end
    @doctors = Doctor.where(sql)
    count = @doctors.count
    totalpages = count % params[:rows].to_i == 0 ? count / params[:rows].to_i : count / params[:rows].to_i + 1
    @doctors = Doctor.where(sql).limit(params[:rows].to_i).offset(params[:rows].to_i*(params[:page].to_i-1))
    render :json => {:doctors => @doctors.as_json, :totalpages => totalpages, :currpage => params[:page].to_i, :totalrecords => count}
  end

  def save_doctors
    @group = Group.find(params[:group_id])
    @doctors = Doctor.where(" id in (#{params[:doctor_ids].join(',')})")
    @group.doctors << @doctors
    render :json => {:success => true}
  end

  def del_doctor_group
    if params[:doctor_id] && params[:group_id]
      if DoctorsGroup.where(:doctor_id => params[:doctor_id], :group_id => params[:group_id]).delete_all
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
      set_group
      destroy
    elsif params[:oper] == 'edit'
      set_group
      update
    end
  end

  # GET /groups/1
  # GET /groups/1.json
  def show
  end

  # GET /groups/new
  def new
    @group = Group.new
    render :partial => 'groups/add'
  end

  # GET /groups/1/edit
  def edit
    render :partial => 'groups/edit'
  end

  # POST /groups
  # POST /groups.json
  def create
    @group = Group.new(group_params)
    if current_user
      @group.create_user_id = current_user.id
      @group.create_user = current_user.name
    end
    if @group.save
      render :json => {:success => true}
    else
      render :json=> {:success => false, :errors => '添加失败！'}
    end

    #respond_to do |format|
    #  if @group.save
    #    format.html { redirect_to @group, notice: 'Admin was successfully created.' }
    #    format.json { render :show, status: :created, location: @group }
    #  else
    #    format.html { render :new }
    #    format.json { render json: @group.errors, status: :unprocessable_entity }
    #  end
    #end
  end

  # PATCH/PUT /groups/1
  # PATCH/PUT /groups/1.json
  def update
    if @group.photo && (@group.photo != group_params[:photo])
      photo_name = @group.photo[@group.photo.rindex('/')+1, @group.photo.length]
      deleteFromAliyun(photo_name, Settings.aliyunOSS.beijing_service ,Settings.aliyunOSS.image_bucket)
    end
    if @group.update(group_params)
      render :json => {:success => true}
    else
      render :json => {:success => false, :errors => '修改失败！'}
    end
    #respond_to do |format|
    #  if @group.update(group_params)
    #    format.html { redirect_to @group, notice: 'Admin was successfully updated.' }
    #    format.json { render :show, status: :ok, location: @group }
    #  else
    #    format.html { render :edit }
    #    format.json { render json: @group.errors, status: :unprocessable_entity }
    #  end
    #end
  end

  # DELETE /groups/1
  # DELETE /groups/1.json
  def destroy
    photo_name = @group.photo[@group.photo.rindex('/')+1, @group.photo.length]
    deleteFromAliyun(photo_name, Settings.aliyunOSS.beijing_service, Settings.aliyunOSS.image_bucket)
    if @group.destroy
      render :json => {:success => true}
    end
    #respond_to do |format|
    #  format.html { redirect_to groups_url, notice: 'Admin was successfully destroyed.' }
    #  format.json { head :no_content }
    #end
  end

  def batch_delete
    if params[:ids]
      @groups = Group.where("id in (#{params[:ids].join(',')})")
      if @groups.delete_all
        render :json => {:success => true}
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_group
      @group = Group.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def group_params
      params.permit(:id, :name, :desc, :photo, :web_site, :create_user_id, :create_user, :expert_count, :sort)
    end
end
