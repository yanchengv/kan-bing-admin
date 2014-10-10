# encoding:utf-8
class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users
  # GET /users.json
  def index
  end

  def show_index
    sql = 'true'
    if params[:name] && params[:name] != ''
      sql << " and name like '%#{params[:name]}%'"
    end
    if params[:email] && params[:email] != ''
      sql << " and email like '%#{params[:email]}%'"
    end
    if params[:photo] && params[:photo] != ''
      sql << " and photo like '%#{params[:photo]}%'"
    end
    if params[:doctor_id] && params[:doctor_id] != ''
      sql << " and doctor_id = #{params[:doctor_id]}"
    end
    if params[:patient_id] && params[:patient_id] != ''
      sql << " and patient_id = #{params[:patient_id]}"
    end
    @users = User.where(sql)
    count = @users.count
    totalpages = count % params[:rows].to_i == 0 ? count / params[:rows].to_i : count / params[:rows].to_i + 1
    @users = @users.limit(params[:rows].to_i).offset(params[:rows].to_i*(params[:page].to_i-1))
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
    if @user.save
      render :json => {:success => true}
    else
      render :json => {:success => false, :errors => '添加失败！'}
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
    if @user.update(user_params)
      render :json => {:success => true}
    else
      render :json => {:success => false, :errors => '修改失败！'}
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
    if @user.destroy
      render :json => {:success => true}
    end
    #respond_to do |format|
    #  format.html { redirect_to users_url, notice: 'Admin was successfully destroyed.' }
    #  format.json { head :no_content }
    #end
  end

  def setting
    render template: 'users/setting'
  end

  #医生
  def get_doctors
    @doctors = Doctor.where('id not in (select doctor_id from users where doctor_id is not null)')
    count = @doctors.count
    totalpages = count % params[:rows].to_i == 0 ? count / params[:rows].to_i : count / params[:rows].to_i + 1
    @doctors = @doctors.limit(params[:rows].to_i).offset(params[:rows].to_i*(params[:page].to_i-1))
    render :json => {:doctors => @doctors.as_json, :totalpages => totalpages, :currpage => params[:page].to_i, :totalrecords => count}
  end

  #护士
  def get_patients
    @patients = Patient.where('id not in (select patient_id from users where patient_id is not null)')
    count = @patients.count
    totalpages = count % params[:rows].to_i == 0 ? count / params[:rows].to_i : count / params[:rows].to_i + 1
    @patients = @patients.limit(params[:rows].to_i).offset(params[:rows].to_i*(params[:page].to_i-1))
    render :json => {:patients => @patients.as_json, :totalpages => totalpages, :currpage => params[:page].to_i, :totalrecords => count}
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end


  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.permit(:id, :name, :password, :password_confirmation, :patient_id, :doctor_id, :nurse_id, :is_enabled, :created_by, :manager_id, :level,:technician_id)
  end
end
