class HospitalsController < ApplicationController
  before_filter :signed_in_user
  before_action :set_hospital, only: [:show, :edit, :update, :destroy]

  # GET /hospitals
  # GET /hospitals.json
  def index
    @opr_flag=true
    if current_user.admin_type == '医院管理员'
      @opr_flag=false
    end
    @provinces = Province.all
    @cities = City.all

    render partial: 'hospitals/hospital_manage'
  end

  def show_index
    sql = 'true'
    hos_id = current_user.hospital_id
    if !hos_id.nil? && hos_id != ''
      sql << " and (id = #{hos_id}) "
    end
    if !params[:province_id].nil? && params[:province_id] != '0' && params[:province_id] != 'null'
      sql << " and province_id = #{params[:province_id]}"
    end
    if !params[:city_id].nil? && params[:city_id] != '0' && params[:city_id] != 'null'
      sql << " and city_id = #{params[:city_id]}"
    end
    if !params[:name].nil? && params[:name] != '' && params[:name] != 'null'
      sql << " and (name like '%#{params[:name]}%' or spell_code like '%#{params[:name]}%' or short_name like '%#{params[:name]}%')"
    end
    count = Hospital.where(sql).count
    totalpages = count % params[:rows].to_i == 0 ? count / params[:rows].to_i : count / params[:rows].to_i + 1
    if params[:page].to_i > totalpages
      params[:page] = 1
    end
    @hospitals = Hospital.where(sql).limit(params[:rows].to_i).offset(params[:rows].to_i*(params[:page].to_i-1))
    render :json => {:hospitals => @hospitals.as_json(:include => [{:province => {:only => [:id, :name]}}, {:city => {:only => [:id, :name]}}]), :totalpages => totalpages, :currpage => params[:page].to_i, :totalrecords => count}
  end

  #整理医院数据用 tmpmethod
  def show_index_search
     q = "true"
     if params[:city_id] == "true"
       q << " and city_id  is  null "
     end

     if params[:province_id] == "true"
       q << " and province_id  is  null "
     end

     if params[:city_name] == "true"
       q << " and city_name ='' "
     end

     if params[:province_name] == "true"
       q << " and province_name = '' "
     end
    if q =="true"
      @hospitals =  Hospital.where(q).limit(16)
    else
      @hospitals =  Hospital.where(q)
    end

     totalpages =1
     count =  @hospitals.count
     render :json => {:hospitals => @hospitals.as_json(:include => [{:province => {:only => [:id, :name]}}, {:city => {:only => [:id, :name]}}]), :totalpages => totalpages, :currpage => params[:page].to_i, :totalrecords => count}
  end

  def oper_action
    if params[:oper] == 'add'
      create
    elsif params[:oper] == 'del'
      set_hospital
      destroy
    elsif params[:oper] == 'edit'
      set_hospital
      update
    end
  end

  # GET /hospitals/1
  # GET /hospitals/1.json
  def show
  end

  # GET /hospitals/new
  def new
    @hospital = Hospital.new
  end

  # GET /hospitals/1/edit
  def edit
  end

  # POST /hospitals
  # POST /hospitals.json
  def create
    @hospital = Hospital.new(hospital_params)
    if @hospital.save
      render :json => {:success => true}
    else
      render :json=> {:success => false, :errors => '添加失败！'}
    end

    #respond_to do |format|
    #  if @hospital.save
    #    format.html { redirect_to @hospital, notice: 'Admin was successfully created.' }
    #    format.json { render :show, status: :created, location: @hospital }
    #  else
    #    format.html { render :new }
    #    format.json { render json: @hospital.errors, status: :unprocessable_entity }
    #  end
    #end
  end

  # PATCH/PUT /hospitals/1
  # PATCH/PUT /hospitals/1.json
  def update
    if @hospital.update(hospital_params)
      render :json => {:success => true}
    else
      render :json => {:success => false, :errors => '修改失败！'}
    end
    #respond_to do |format|
    #  if @hospital.update(hospital_params)
    #    format.html { redirect_to @hospital, notice: 'Admin was successfully updated.' }
    #    format.json { render :show, status: :ok, location: @hospital }
    #  else
    #    format.html { render :edit }
    #    format.json { render json: @hospital.errors, status: :unprocessable_entity }
    #  end
    #end
  end

  # DELETE /hospitals/1
  # DELETE /hospitals/1.json
  def destroy
   if @hospital.destroy
     render :json => {:success => true}
   end
    #respond_to do |format|
    #  format.html { redirect_to hospitals_url, notice: 'Admin was successfully destroyed.' }
    #  format.json { head :no_content }
    #end
  end
  #省
  def get_provinces
    @provinces = Province.all
    pros = {}
    @provinces.each do |pro|
      pros[pro.id] = pro.name
    end
    render :json => {:provinces => pros.as_json}
  end
  #市
  def get_cities
    if params[:province_id] && params[:province_id] != ''
      @cities = City.where(:province_id => params[:province_id])
    else
      @cities = City.all
    end
    cities = {}
    @cities.each do |city|
      cities[city.id] = city.name
    end
    render :json => {:cities => cities.as_json}
  end
  ##医院等级
  def hospital_rank
    @dictionaries = Dictionary.where(:dictionary_type_id => 5)
    ranks = {}
    @dictionaries.each do |dic|
      ranks[dic.name] = dic.name
    end
    render :json => {:ranks => ranks.as_json}
  end

  #是否显示于首页
   def change_index_page
     if params[:id] && params[:indexpage] && params[:id] != '' && params[:indexpage] != ''
       puts "=================indexpage ==== #{params[:indexpage]}"
       @hospital = Hospital.find(params[:id])
       if @hospital.update_attributes(:indexpage => params[:indexpage])
         render :json => {:success => true}
       else
         render :json => {:success => false}
       end
     else
       render :json => {:success => false}
     end
   end


  def setting
    render template: 'hospitals/setting'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_hospital
      @hospital = Hospital.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def hospital_params
      params.permit(:id, :name, :short_name, :spell_code,:address, :phone, :description, :rank, :province_id, :province_name, :city_id, :city_name,
                    :key_departments, :operation_mode, :email, :hospital_site, :fax_number, :indexpage, :sort)
    end
end
