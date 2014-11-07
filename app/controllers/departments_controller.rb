class DepartmentsController < ApplicationController
  before_action :set_department, only: [:show, :edit, :update, :destroy]

  # GET /departments
  # GET /departments.json
  def index
  end

  def show_index
    sql = 'true'
    hos_id = current_user.hospital_id
    if !hos_id.nil? && hos_id != ''
      sql << " and (hospital_id = #{hos_id}) "
    end
    if !params[:department_type].nil? && params[:department_type] != '-1' && params[:department_type] != 'null'
      sql << " and department_type = #{params[:department_type]}"
    end
    if !params[:name].nil? && params[:name] != '' && params[:name] != 'null'
      sql << " and (name like '%#{params[:name]}%' or spell_code like '%#{params[:name]}%' or short_name like '%#{params[:name]}%')"
    end
    if params[:hospital_id] && params[:hospital_id] != '' && params[:hospital_id] != 'null'
      sql << " and hospital_id = #{params[:hospital_id]}"
    end
    @departments = Department.where(sql)
    count = @departments.count
    totalpages = count % params[:rows].to_i == 0 ? count / params[:rows].to_i : count / params[:rows].to_i + 1
    @departments = @departments.limit(params[:rows].to_i).offset(params[:rows].to_i*(params[:page].to_i-1))
    render :json => {:departments => @departments.as_json, :totalpages => totalpages, :currpage => params[:page].to_i, :totalrecords => count}
  end

  def oper_action
    if params[:oper] == 'add'
      create
    elsif params[:oper] == 'del'
      set_department
      destroy
    elsif params[:oper] == 'edit'
      set_department
      update
    end
  end

  # GET /departments/1
  # GET /departments/1.json
  def show
  end

  # GET /departments/new
  def new
    @department = Department.new
  end

  # GET /departments/1/edit
  def edit
  end

  # POST /departments
  # POST /departments.json
  def create
    @department = Department.new(department_params)
    if @department.save
      render :json => {:success => true}
    else
      render :json=> {:success => false, :errors => '添加失败！'}
    end

    #respond_to do |format|
    #  if @department.save
    #    format.html { redirect_to @department, notice: 'Admin was successfully created.' }
    #    format.json { render :show, status: :created, location: @department }
    #  else
    #    format.html { render :new }
    #    format.json { render json: @department.errors, status: :unprocessable_entity }
    #  end
    #end
  end

  # PATCH/PUT /departments/1
  # PATCH/PUT /departments/1.json
  def update
    if @department.update(department_params)
      render :json => {:success => true}
    else
      render :json => {:success => false, :errors => '修改失败！'}
    end
    #respond_to do |format|
    #  if @department.update(department_params)
    #    format.html { redirect_to @department, notice: 'Admin was successfully updated.' }
    #    format.json { render :show, status: :ok, location: @department }
    #  else
    #    format.html { render :edit }
    #    format.json { render json: @department.errors, status: :unprocessable_entity }
    #  end
    #end
  end

  # DELETE /departments/1
  # DELETE /departments/1.json
  def destroy
   if @department.destroy
     render :json => {:success => true}
   end
    #respond_to do |format|
    #  format.html { redirect_to departments_url, notice: 'Admin was successfully destroyed.' }
    #  format.json { head :no_content }
    #end
  end

  def setting
    render template: 'departments/setting'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_department
      @department = Department.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def department_params
      params.permit(:id, :name, :short_name, :spell_code,:phone_number, :description, :hospital_id, :province_id, :city_id, :department_type, :state, :sort)
    end
end
