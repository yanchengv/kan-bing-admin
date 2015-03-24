#encoding:utf-8
class DoctorFriendshipsController < ApplicationController
  before_filter :signed_in_user
    before_action :set_doctor_friendship, only: [:show, :edit, :update, :destroy]

    # GET /doctor_friendships
    # GET /doctor_friendships.json
    def index
      all_menus
      render template:  'doctor_friendships/doctor_friendship'
    end

    def show_index
      sql1 = 'true'
      if current_user.admin_type == '医院管理员'
        if !current_user.hospital_id.nil? && !current_user.hospital_id != ''
          sql1 << " and hospital_id = #{current_user.hospital_id}"
        else
          sql1 << " and hospital_id = 0"
        end
      elsif current_user.admin_type == '科室管理员'
        if !current_user.department_id.nil? && !current_user.department_id != ''
          sql1 << " and department_id = #{current_user.department_id}"
        else
          sql1 << " and department_id = 0"
        end
      elsif current_user.admin_type == '机构管理员'
        if !current_user.organization_id.nil? && !current_user.organization_id != ''
          sql1 << " and organization_id = #{current_user.organization_id}"
        else
          sql1 << " and organization_id = 0"
        end
      else
      end

      #hos_id = current_user.hospital_id
      #dep_id = current_user.department_id
      #if !hos_id.nil? && hos_id != ''
      #  if !dep_id.nil? && dep_id != ''
      #    sql << " and hospital1_id=#{hos_id} and department1_id=#{dep_id}"
      #  else
      #    sql << " and hospital1_id=#{hos_id}"
      #  end
      #end
      sql = "true"
      if !params[:name].nil? && params[:name] != '' && params[:name] != 'null'
        sql << " and ( doctor1_id in (select id from doctors where name = '#{params[:name]}' and #{sql1}) or doctor2_id in (select id from doctors where name = '#{params[:name]}' and #{sql1}) )"
      else
        sql << " and ( doctor1_id in (select id from doctors where #{sql1}) or doctor2_id in (select id from doctors where #{sql1}) )"
      end
      count = DoctorFriendship.where(sql).count
      totalpages = count % params[:rows].to_i == 0 ? count / params[:rows].to_i : count / params[:rows].to_i + 1
      if params[:page].to_i > totalpages
        params[:page] = 1
      end
      @doctor_friendships = DoctorFriendship.where(sql).limit(params[:rows].to_i).offset(params[:rows].to_i*(params[:page].to_i-1))
      render :json => {:doctor_friendships => @doctor_friendships.as_json(:include => [{:doctor1 => {:only => [:id, :name]}}, {:doctor2 => {:only => [:id, :name]}}]), :totalpages => totalpages, :currpage => params[:page].to_i, :totalrecords => count}
    end

    #获取非医友关系的医生
    def get_doctors
      if params[:str] == 'default'
        @doctors = {}
        totalpages = 0
        params[:page] = 1
        count = 0
      else
        sql = 'true'
        if !current_user.nil?
          if current_user.admin_type == '医院管理员'
            if !current_user.hospital_id.nil? && !current_user.hospital_id != ''
              sql << " and hospital_id = #{current_user.hospital_id}"
            else
              sql << " and hospital_id = 0"
            end
          elsif current_user.admin_type == '科室管理员'
            if !current_user.department_id.nil? && !current_user.department_id != ''
              sql << " and department_id = #{current_user.department_id}"
            else
              sql << " and department_id = 0"
            end
          elsif current_user.admin_type == '机构管理员'
            if !current_user.organization_id.nil? && !current_user.organization_id != ''
              sql << " and organization_id = #{current_user.organization_id}"
            else
              sql << " and organization_id = 0"
            end
          else
            if params[:hospital_id] && params[:hospital_id] != '' && params[:hospital_id] != 'all' && params[:hospital_id] != 'null' && params[:hospital_id] != 'undefined'
              sql << " and hospital_id = #{params[:hospital_id]}"
            end
            if params[:department_id] && params[:department_id] != '' && params[:department_id] != 'all' && params[:department_id] != 'null' && params[:department_id] != 'undefined'
              sql << " and department_id = #{params[:department_id]}"
            end
          end
        end
        if params[:province_id] && params[:province_id] != '' && params[:province_id] != 'all' && params[:province_id] != 'null' && params[:province_id] != 'undefined'
          sql << " and province_id = #{params[:province_id]}"
        end
        if params[:city_id] && params[:city_id] != '' && params[:city_id] != 'all' && params[:city_id] != 'null' && params[:city_id] != 'undefined'
          sql << " and city_id = #{params[:city_id]}"
        end
        if params[:name] && params[:name] != '' && params[:name] != 'null' && params[:name] != 'undefined'
          sql << " and name like '%#{params[:name]}%' "
        end
        if params[:doctor_id] && params[:doctor_id] != '' && params[:doctor_id] != 'null' && params[:doctor_id] != 'undefined'
          sql << " and id != #{params[:doctor_id]} and id not in (select doctor1_id from doctor_friendships where doctor2_id = #{params[:doctor_id]}) and id not in (select doctor2_id from doctor_friendships where doctor1_id = #{params[:doctor_id]})"
        end
        count = Doctor.where(sql).count
        totalpages = count % params[:rows].to_i == 0 ? count / params[:rows].to_i : count / params[:rows].to_i + 1
        if params[:page].to_i > totalpages
          params[:page] = 1
        end
        @doctors = Doctor.where(sql).limit(params[:rows].to_i).offset(params[:rows].to_i*(params[:page].to_i-1))
      end
      render :json => {:doctors => @doctors.as_json, :totalpages => totalpages, :currpage => params[:page].to_i, :totalrecords => count}
    end
  #保存关系
  def save_friendship
    if params[:doctor1_id] && params[:doctor2_ids]
      params[:doctor2_ids].each do |doc|
        @doctor_friendships = DoctorFriendship.where(:doctor1_id => params[:doctor1_id], :doctor2_id => doc)
        if @doctor_friendships.empty? || @doctor_friendships.nil?
          DoctorFriendship.create(:doctor1_id => params[:doctor1_id], :doctor2_id => doc)
        end
      end
      render :json => {:success => true}
    else
      render :json => {:success => false}
    end
  end

  #获取省
  def get_provinces
    @pros = Province.select(:id, :name).all
    pros = {}
    @pros.each do |pro|
      pros[pro.id] = pro.namee
    end
    render :json => {:provinces => pros.as_json}
  end

  #获取市
  def get_cities
    @cities = City.select(:id, :name).all
    if params[:province_id] && params[:province_id] != '' && params[:province_id] != 'null'
      @cities = @cities.where(:province_id => params[:province_id])
    end
    cities = {}
    @cities.each do |city|
      cities[city.id] = city.name
    end
    render :json => {:cities => cities.as_json}
  end

  #获取医院
  def get_hospitals

=begin
    if  params[:province_id] && params[:province_id] != '' && params[:city_id] && params[:city_id] != '' && params[:province_id] != 'null' && params[:city_id] != 'null'
      if params[:province_id] && params[:province_id] != '' && params[:province_id] != 'null'
        @hospitals = Hospital.where(:province_id => params[:province_id])
      end
=end
      if params[:city_id] && params[:city_id] != '' && params[:city_id] != 'null'
        if @hospitals.nil?
          @hospitals = Hospital.where(:city_id => params[:city_id])
        else
          @hospitals = @hospitals.where(:city_id => params[:city_id])
        end
      end
=begin
    else
      @hospitals = Hospital.select(:id, :name).all.limit(50)
    end
=end
    hospitals = {}
    @hospitals.each do |hos|
      hospitals[hos.id] = hos.name
    end
    render :json => {:hospitals => hospitals.as_json}
  end

  #获取科室
  def get_departments
=begin
    if params[:province_id] && params[:province_id] != '' && params[:city_id] && params[:city_id] != '' && params[:hospital_id] && params[:hospital_id] != '' && params[:province_id] != 'null' && params[:city_id] != 'null' && params[:hospital_id] != 'null'
      if params[:province_id] && params[:province_id] != '' && params[:province_id] != 'null'
        @departments = Department.where(:province_id => params[:province_id])
      end
      if params[:city_id] && params[:city_id] != '' && params[:city_id] != 'null'
        if @departments.nil?
          @departments = Department.where(:city_id => params[:city_id])
        else
          @departments = @departments.where(:city_id => params[:city_id])
        end
      end
=end
      if params[:hospital_id] && params[:hospital_id] != '' && params[:hospital_id] != 'null'
        if @departments.nil?
          @departments = Department.where(:hospital_id => params[:hospital_id])
        else
          @departments = @departments.where(:hospital_id => params[:hospital_id])
        end
      end
=begin
    else
      @departments = Department.select(:id, :name).all.limit(50)
    end
=end
    departments = {}
    @departments.each do |dept|
      departments[dept.id] = dept.name
    end
    render :json => {:departments => departments.as_json}
  end

    def oper_action
      if params[:oper] == 'add'
        create
      elsif params[:oper] == 'del'
        set_doctor_friendship
        destroy
      elsif params[:oper] == 'edit'
        set_doctor_friendship
        update
      end
    end

    # GET /doctor_friendships/1
    # GET /doctor_friendships/1.json
    def show
    end

    # GET /doctor_friendships/new
    def new
      @provinces = Province.select(:id, :name).all
=begin
      @cities = City.select(:id, :name).all
      @hospitals = Hospital.select(:id, :name).all
      @departments = Department.select(:id, :name).all
=end
      render :partial => 'doctor_friendships/doctor1s_list'
    end

    # GET /doctor_friendships/1/edit
    def edit
    end

    # POST /doctor_friendships
    # POST /doctor_friendships.json
    def create
      @doctor_friendship = DoctorFriendship.new(doctor_friendship_params)
      @doctor_friendships = DoctorFriendship.where(:doctor1_id => @doctor_friendship.doctor1_id, :doctor2_id => @doctor_friendship.doctor2_id)
      @doctor_friendships1 = DoctorFriendship.where(:doctor1_id => @doctor_friendship.doctor2_id, :doctor2_id => @doctor_friendship.doctor1_id)
      if @doctor_friendships.empty? && @doctor_friendships1.empty?
        if @doctor_friendship.save
          render :json => {:success => true}
        else
          render :json => {:success => false, :errors => '添加失败！'}
        end
      else
        render :json => {:success => false, :errors => '关联关系已存在！'}
      end


      #respond_to do |format|
      #  if @doctor_friendship.save
      #    format.html { redirect_to @doctor_friendship, notice: 'Admin was successfully created.' }
      #    format.json { render :show, status: :created, location: @doctor_friendship }
      #  else
      #    format.html { render :new }
      #    format.json { render json: @doctor_friendship.errors, status: :unprocessable_entity }
      #  end
      #end
    end

    # PATCH/PUT /doctor_friendships/1
    # PATCH/PUT /doctor_friendships/1.json
    def update
      if @doctor_friendship.update(doctor_friendship_params)
        render :json => {:success => true}
      else
        render :json => {:success => false, :errors => '修改失败！'}
      end
      #respond_to do |format|
      #  if @doctor_friendship.update(doctor_friendship_params)
      #    format.html { redirect_to @doctor_friendship, notice: 'Admin was successfully updated.' }
      #    format.json { render :show, status: :ok, location: @doctor_friendship }
      #  else
      #    format.html { render :edit }
      #    format.json { render json: @doctor_friendship.errors, status: :unprocessable_entity }
      #  end
      #end
    end

    # DELETE /doctor_friendships/1
    # DELETE /doctor_friendships/1.json
    def destroy
      if @doctor_friendship.destroy
        render :json => {:success => true}
      end
      #respond_to do |format|
      #  format.html { redirect_to doctor_friendships_url, notice: 'Admin was successfully destroyed.' }
      #  format.json { head :no_content }
      #end
    end
    #批量删除
    def batch_delete
      if params[:ids]
        @doctor_friendships = DoctorFriendship.where("id in (#{params[:ids].join(',')})")
        if @doctor_friendships.delete_all
          render :json => {:success => true}
        end
      end
    end

    def setting
      render template: 'doctor_friendships/setting'
    end

    private
    # Use callbacks to share common setup or constraints between actions.
    def set_doctor_friendship
      @doctor_friendship = DoctorFriendship.find(params[:id])
    end


    # Never trust parameters from the scary internet, only allow the white list through.
    def doctor_friendship_params
      params.permit(:id, :doctor1_id, :doctor2_id)
    end
  end
