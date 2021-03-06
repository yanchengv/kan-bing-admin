# encoding:utf-8
class UsersController < ApplicationController
  before_filter :signed_in_user
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users
  # GET /users.json
  def index
    all_menus
   render template:  'users/user_manage'
  end

  def show_index
    sql = 'true'
    hos_id = current_user.hospital_id
    dep_id = current_user.department_id
    if params[:user_type] == 'doctor'
      sql << " and (doctor_id is not null or doctor_id != '')"
    end
    if params[:user_type] == 'patient'
      sql << " and (patient_id is not null or patient_id != '')"
    end
    if !hos_id.nil? && hos_id != ''
      if !dep_id.nil? && dep_id != ''
        doc = "select id from doctors where hospital_id=#{hos_id} and department_id=#{dep_id}"
        pat = "select id from patients where hospital_id=#{hos_id} and department_id=#{dep_id}"
      else
        doc = "select id from doctors where hospital_id=#{hos_id}"
        pat = "select id from patients where hospital_id=#{hos_id}"
      end
      sql << " and (doctor_id in ("+doc+") or patient_id in ("+pat+")) "
    end
    if params[:name] && params[:name] != '' && params[:name] != 'null'
      sql << " and( name like '%#{params[:name]}%' or  nick_name like '%#{params[:name]}%' or  real_name like '%#{params[:name]}%') "
    end
    if params[:email] && params[:email] != '' && params[:email] != 'null'
      sql << " and email like '%#{params[:email]}%'"
    end
    if params[:mobile_phone] && params[:mobile_phone] != '' && params[:mobile_phone] != 'null'
      sql << " and mobile_phone like '%#{params[:mobile_phone]}%'"
    end
    if params[:verification_code] && params[:verification_code] != '' && params[:verification_code] != 'null'
      sql << " and verification_code like '%#{params[:verification_code]}%'"
    end
    if params[:doctor_id] && params[:doctor_id] != '' && params[:doctor_id] != 'null'
      sql << " and doctor_id = #{params[:doctor_id]}"
    end
    if params[:patient_id] && params[:patient_id] != '' && params[:patient_id] != 'null'
      sql << " and patient_id = #{params[:patient_id]}"
    end
    if params[:is_enabled] && params[:is_enabled] != '' && params[:is_enabled] != 'null'
      sql << " and is_enabled = #{params[:is_enabled]}"
    end
   # @users = User.where(sql)
    count = User.where(sql).count
    totalpages = count % params[:rows].to_i == 0 ? count / params[:rows].to_i : count / params[:rows].to_i + 1
    if params[:page].to_i > totalpages
      params[:page] = 1
    end
    @users = User.where(sql).limit(params[:rows].to_i).offset(params[:rows].to_i*(params[:page].to_i-1))
    render :json => {:users => @users.as_json, :totalpages => totalpages, :currpage => params[:page].to_i, :totalrecords => count}
  end

  def oper_action
    if params[:oper] == 'add'
      create
    elsif params[:oper] == 'del'
      set_user
      destroy
    elsif params[:oper] == 'edit'
      set_user
      update
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)
    if @user.password.nil? || @user.password == ''
      @user.password = '123456'
    end
    if !@user.patient_id.nil? && @user.patient_id != ''
      @u_p = User.where(:patient_id => @user.patient_id)
      if @u_p.empty? || @u_p.nil?
        if @user.check_obj(user_params) == 'ok'
          if @user.save
            if @user.patient
              @user.patient.update(is_public: true)
              #如果该患者有医生身份,同时改变医生的is_public的值
              @doctors = Doctor.where(:patient_id => @user.patient.id)
              if !@doctors.empty?
                @doctors.first.update_attributes(:is_public => true)
              end
            end
            render :json => {:success => true}
          else
            render :json => {:success => false, :errors => '患者用户添加失败！'}
          end
        else
          render :json => {:success => false, :errors => @user.check_obj(user_params)}
        end
      end
    end
    if !@user.doctor_id.nil? && @user.doctor_id != ''
      @u_d = User.where(:doctor_id => @user.doctor_id)
      if @u_d.empty? || @u_d.nil?
        if @user.check_obj(user_params) == 'ok'
          if @user.save
            if @user.doctor
              @user.doctor.update(is_public: true)
              #如果该医生有患者身份,同时改变患者的is_public的值
              @patients = Patient.where(:id => @user.doctor.patient_id)
              if !@patients.empty?
                @patients.first.update_attributes(:is_public => true)
              end
            end
            render :json => {:success => true}
          else
            render :json => {:success => false, :errors => '医生用户添加失败！'}
          end
        else
          render :json => {:success => false, :errors => @user.check_obj(user_params)}
        end
      end
    end


    #respond_to do |format|
    #  if @user.save
    #    format.html { redirect_to @user, notice: 'Admin was successfully created.' }
    #    format.json { render :show, status: :created, location: @user }
    #  else
    #    format.html { render :new }
    #    format.json { render json: @user.errors, status: :unprocessable_entity }
    #  end
    #end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    if params[:password].nil? && params[:password] == ''    #密码为空时,表示不修改密码
      params[:password] = @user.password
    end
    if @user.check_obj(user_params) == 'ok'
      if @user.update(user_params)
        render :json => {:success => true}
      else
        render :json => {:success => false, :errors => '修改失败！'}
      end
    else
      render :json => {:success => false, :errors => @user.check_obj(user_params)}
    end

    #respond_to do |format|
    #  if @user.update(user_params)
    #    format.html { redirect_to @user, notice: 'Admin was successfully updated.' }
    #    format.json { render :show, status: :ok, location: @user }
    #  else
    #    format.html { render :edit }
    #    format.json { render json: @user.errors, status: :unprocessable_entity }
    #  end
    #end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    if !@user.doctor_id.nil? && @user.doctor_id != ''
      @doctors = Doctor.where(:id => @user.doctor_id)
      if !@doctors.nil? && !@doctors.empty?
        @doctors.first.update_attributes(:is_public => false)
        if !@doctors.first.patient_id.nil? && @doctors.first.patient_id != ''
          @patients = Patient.where(:id => @doctors.first.patient_id)
          if !@patients.nil? && !@patients.empty?
            @patients.first.update_attributes(:is_public => false)
          end
        end
      end
    end
    if !@user.patient_id.nil? && @user.patient_id != ''
      @patients = Patient.where(:id => @user.patient_id)
      if !@patients.nil? && !@patients.empty?
        @patients.first.update_attributes(:is_public => false)
        @doctors = Doctor.where(:patient_id => @patients.first.id)
        if !@doctors.empty?
          @doctors.first.update_attributes(:is_public => false)
        end
      end
    end
    if @user.destroy
      render :json => {:success => true}
    end
    #respond_to do |format|
    #  format.html { redirect_to users_url, notice: 'Admin was successfully destroyed.' }
    #  format.json { head :no_content }
    #end
  end

  def batch_delete
    if params[:ids]
      @users = User.where("id in (#{params[:ids].join(',')}) ")
      if !@users.empty?
        @users.each do |user|
          if !user.doctor_id.nil? && user.doctor_id != ''
            @doctors = Doctor.where(:id => user.doctor_id)
            if !@doctors.nil? && !@doctors.empty?
              @doctors.first.update_attributes(:is_public => false)
              if !@doctors.first.patient_id.nil? && @doctors.first.patient_id != ''
                @patients = Patient.where(:id => @doctors.first.patient_id)
                if !@patients.nil? && !@patients.empty?
                  @patients.first.update_attributes(:is_public => false)
                end
              end
            end
          end
          if !user.patient_id.nil? && user.patient_id != ''
            @patients = Patient.where(:id => user.patient_id)
            if !@patients.nil? && !@patients.empty?
              @patients.first.update_attributes(:is_public => false)
              @doctors = Doctor.where(:patient_id => @patients.first.id)
              if !@doctors.empty?
                @doctors.first.update_attributes(:is_public => false)
              end
            end
          end
        end
      end
      if @users.delete_all
        render :json => {:success => true}
      end
    end
  end

  def setting
    render template: 'users/setting'
  end

  #医生
  def get_doctors
    sql="is_public = false"
    hos_id = current_user.hospital_id
    dep_id = current_user.department_id
    if !hos_id.nil? && hos_id != ''
      sql << " and hospital_id=#{hos_id}"
    end
    if !dep_id.nil? && dep_id != ''
      sql << " and department_id=#{dep_id}"
    end
    if params[:name] && params[:name] != ''
      sql << " and (name like '%#{params[:name]}%' or spell_code like '%#{params[:name]}%')"
    end
    if params[:email] && params[:email] != ''
      sql << " and email like '%#{params[:email]}%'"
    end
    if params[:mobile_phone] && params[:mobile_phone] != ''
      sql << " and mobile_phone like '%#{params[:mobile_phone]}%'"
    end
    if params[:credential_type_number] && params[:credential_type_number] != ''
      sql << " and credential_type_number like '%#{params[:credential_type_number]}%'"
    end
    @doctors = Doctor.where(sql)
    count = @doctors.count
    totalpages = count % params[:rows].to_i == 0 ? count / params[:rows].to_i : count / params[:rows].to_i + 1
    @doctors = @doctors.limit(params[:rows].to_i).offset(params[:rows].to_i*(params[:page].to_i-1))
    render :json => {:doctors => @doctors.as_json, :totalpages => totalpages, :currpage => params[:page].to_i, :totalrecords => count}
  end

  #患者
  def get_patients
    sql="is_public = false"
    hos_id = current_user.hospital_id
    dep_id = current_user.department_id
    if !hos_id.nil? && hos_id != ''
      sql << " and hospital_id=#{hos_id}"
    end
    if !dep_id.nil? && dep_id != ''
      sql << " and department_id=#{dep_id}"
    end
    if params[:name] && params[:name] != ''
      sql << " and (name like '%#{params[:name]}%' or spell_code like '%#{params[:name]}%')"
    end
    if params[:email] && params[:email] != ''
      sql << " and email like '%#{params[:email]}%'"
    end
    if params[:mobile_phone] && params[:mobile_phone] != ''
      sql << " and mobile_phone like '%#{params[:mobile_phone]}%'"
    end
    if params[:credential_type_number] && params[:credential_type_number] != ''
      sql << " and credential_type_number like '%#{params[:credential_type_number]}%'"
    end
    @patients = Patient.where(sql)
    count = @patients.count
    totalpages = count % params[:rows].to_i == 0 ? count / params[:rows].to_i : count / params[:rows].to_i + 1
    @patients = @patients.limit(params[:rows].to_i).offset(params[:rows].to_i*(params[:page].to_i-1))
    render :json => {:patients => @patients.as_json, :totalpages => totalpages, :currpage => params[:page].to_i, :totalrecords => count}
  end
#修改状态
  def change_state
    if params[:ids]
      @users = User.where("id in (#{params[:ids].join(',')}")
      @users.each do |user|
        user.update_attribute(:is_enabled, params[:is_enabled])
      end
      render :json => {:success => true}
    else
      if params[:id] && params[:is_enabled]
        @user = User.find(params[:id])
        @user.update_attribute(:is_enabled, params[:is_enabled])
        render :json => {:success => true}
      else
        render :json => {:success => false, :errors => '修改失败！'}
      end
    end

  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end


  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.permit(:id, :name, :password, :password_confirmation, :patient_id, :doctor_id, :nurse_id, :is_enabled, :created_by, :manager_id, :level,:technician_id, :nick_name, :real_name, :verification_code, :mobile_phone, :email, :credential_type_number)
  end
end
