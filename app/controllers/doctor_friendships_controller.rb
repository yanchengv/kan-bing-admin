#encoding:utf-8
class DoctorFriendshipsController < ApplicationController
  before_filter :signed_in_user
    before_action :set_doctor_friendship, only: [:show, :edit, :update, :destroy]

    # GET /doctor_friendships
    # GET /doctor_friendships.json
    def index
      render partial: 'doctor_friendships/doctor_friendship'
    end

    def show_index
      sql = 'true'
      hos_id = current_user.hospital_id
      dep_id = current_user.department_id
      if !hos_id.nil? && hos_id != ''
        if !dep_id.nil? && dep_id != ''
          sql << " and hospital1_id=#{hos_id} and department1_id=#{dep_id}"
        else
          sql << " and hospital1_id=#{hos_id}"
        end
      end
      if !params[:name].nil? && params[:name] != '' && params[:name] != 'null'
        sql << " and doctor1_id in (select id from doctors where name = '#{params[:name]}') or doctor2_id in (select id from doctors where name = '#{params[:name]}')"
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
      if  params[:hospital_id] && params[:hospital_id] != '' && params[:hospital_id] != 'null' && params[:department_id] && params[:department_id] != '' && params[:department_id] != 'null'
        if params[:hospital_id] && params[:hospital_id] != '' && params[:hospital_id] != 'null'
          @doctors = Doctor.where(:hospital_id => params[:hospital_id])
        end
        if params[:department_id] && params[:department_id] != '' && params[:department_id] != 'null'
          if @doctors.nil?
            @doctors = Doctor.where(:department_id => params[:department_id])
          else
            @doctors = @doctors.where(:department_id => params[:department_id])
          end
        end
      else
        sql = 'true'
        hos_id = current_user.hospital_id
        dep_id = current_user.department_id
        if !hos_id.nil? && hos_id != ''
          if !dep_id.nil? && dep_id != ''
            sql << " and hospital_id=#{hos_id} and department_id=#{dep_id}"
          else
            sql << " and hospital_id=#{hos_id}"
          end
        end
        @doctors = Doctor.select(:id, :name).where(sql)
      end
      doctors = {}
      @doctors.each do |doc|
        doctors[doc.id] = doc.name
      end
      render :json => {:doctors => doctors.as_json}
    end

  #获取省
  def get_provinces
    @pros = Province.select(:id, :name).all
    pros = {}
    @pros.each do |pro|
      pros[pro.id] = pro.name
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

    if  params[:province_id] && params[:province_id] != '' && params[:city_id] && params[:city_id] != '' && params[:province_id] != 'null' && params[:city_id] != 'null'
      if params[:province_id] && params[:province_id] != '' && params[:province_id] != 'null'
        @hospitals = Hospital.where(:province_id => params[:province_id])
      end
      if params[:city_id] && params[:city_id] != '' && params[:city_id] != 'null'
        if @hospitals.nil?
          @hospitals = Hospital.where(:city_id => params[:city_id])
        else
          @hospitals = @hospitals.where(:city_id => params[:city_id])
        end
      end
    else
      @hospitals = Hospital.select(:id, :name).all.limit(50)
    end
    hospitals = {}
    @hospitals.each do |hos|
      hospitals[hos.id] = hos.name
    end
    render :json => {:hospitals => hospitals.as_json}
  end

  #获取科室
  def get_departments
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
      if params[:hospital_id] && params[:hospital_id] != '' && params[:hospital_id] != 'null'
        if @departments.nil?
          @departments = Department.where(:hospital_id => params[:hospital_id])
        else
          @departments = @departments.where(:hospital_id => params[:hospital_id])
        end
      end
    else
      @departments = Department.select(:id, :name).all.limit(50)
    end
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
      @doctor_friendship = DoctorFriendship.new
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
      params.permit(:id, :doctor1_id, :doctor2_id, :province1_id, :city1_id, :hospital1_id, :department1_id, :province2_id, :city2_id, :hospital2_id, :department2_id)
    end
  end
