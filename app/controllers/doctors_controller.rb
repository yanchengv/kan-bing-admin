#encoding:utf-8
class DoctorsController < ApplicationController
  require 'httparty'
  include HTTParty
  before_filter :signed_in_user#,:access_control
  before_action :set_doctor, only: [:show, :edit, :update, :destroy]

  # GET /doctors
  # GET /doctors.json
  def index
    @hospitals = nil
    @departments = nil
    if !current_user.hospital_id.nil? && current_user.hospital_id != ''
      @hospitals = Hospital.where(id:current_user.hospital_id)
      if !current_user.department_id.nil? && current_user.department_id != ''
        @departments = Department.where(id:current_user.department_id)
      else
        @departments = Department.where(hospital_id:current_user.hospital_id)
      end
    else
      @hospitals = Hospital.select("id","name").all
    end
    @provinces = Province.select("id","name").all
    @cities = City.select("id","name").all
    render partial: 'doctors/doctor_manage'
  end

  def show_index
    if params[:str] == 'hospital'
      sql = "hospital_id is null or hospital_id = 0 or hospital_id = '' or hospital_name is null or hospital_name = ''"
      page = params[:page].to_i
      records = Doctor.where(sql).count
      @total =records % params[:rows].to_i == 0 ? records / params[:rows].to_i : records / params[:rows].to_i + 1
      if page.to_i>@total.to_i
        page = 1
      end
      @rows = Doctor.where(sql).limit(params[:rows].to_i).offset(params[:rows].to_i*(page.to_i-1))
    elsif params[:str] == 'department'
      sql = "department_id is null or department_id = 0 or department_id = '' or department_name is null or department_name = ''"
      page = params[:page].to_i
      records = Doctor.where(sql).count
      @total =records % params[:rows].to_i == 0 ? records / params[:rows].to_i : records / params[:rows].to_i + 1
      if page.to_i>@total.to_i
        page = 1
      end
      @rows = Doctor.where(sql).limit(params[:rows].to_i).offset(params[:rows].to_i*(page.to_i-1))
    else
          hos_id = current_user.hospital_id
          dep_id = current_user.department_id
          if !params[:pro_id].nil? && params[:pro_id] != '' && params[:pro_id] != 'undefined'
            pro_id = params[:pro_id]
          end
          if !params[:city_id].nil? && params[:city_id] != '' && params[:city_id] != 'undefined'
            city_id = params[:city_id]
          end
          if !params[:hos_id].nil? && params[:hos_id] != '' && params[:hos_id] != 'undefined'
            hos_id = params[:hos_id]
          end
          if !params[:dep_id].nil? && params[:dep_id] != '' && params[:dep_id] != 'all' && params[:dep_id] != 'undefined'
            dep_id = params[:dep_id]
          end
          is_activated = params[:is_activated]
          is_public = params[:is_public]
          noOfRows = params[:rows]
          page = params[:page]
          @doctors_all = nil
          sql = "true"
          if current_user
            if current_user.admin_type == '机构管理员'
              sql << " and organization_id = #{current_user.organization_id}"
            else
              if !hos_id.nil? && hos_id != '' && !dep_id.nil? && dep_id != ''
                @hos = Hospital.where(id: hos_id).first
                @dep = Department.where(id: dep_id).first
                if !@hos.nil?
                  hos_name = @hos.name
                else
                  hos_name = '不存在'
                end
                if !@dep.nil?
                  dep_name = @dep.name
                else
                  dep_name = '不存在'
                end
                sql << " and (hospital_id = #{hos_id} or hospital_name like '%#{hos_name}%') and (department_id=#{dep_id} or department_name like '%#{dep_name}%')"
              elsif !hos_id.nil? && hos_id != ''
                @hos = Hospital.where(id: hos_id).first
                if !@hos.nil?
                  hos_name = @hos.name
                else
                  hos_name = '不存在'
                end
                sql << " and (hospital_id = #{hos_id} or hospital_name like '%#{hos_name}%')"
              end
            end
          end
          if !pro_id.nil? && pro_id != '' && !city_id.nil? && city_id != ''
            @pro = Province.find(pro_id)
            @city = City.find(city_id)
            sql << " and (province_id = #{pro_id} or province_name like '%#{@pro.name}%') and (city_id=#{city_id} or city_name like '%#{@city.name}%')"
          elsif !pro_id.nil? && pro_id != ''
            @pro = Province.find(pro_id)
            sql << " and (province_id = #{pro_id} or province_name like '%#{@pro.name}%')"
          end
          # field = params[:searchField]
          # p params[:searchOper]
          # value = params[:searchString]
          # if !field.nil? && field!='' && !value.nil?
          #   sql << " and #{field} like '%#{value]}%'"
          # end
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
          if is_activated=='0'
            sql << " and is_activated=0"
          end
          if is_activated=='1'
            sql << " and is_activated not in (0)"
          end
          if is_public=='0'
            sql << " and is_public=0"
          end
          if is_public=='1'
            sql << " and is_public=1"
          end
          # @doctors = Doctor.find_by_sql("select SQL_CALC_FOUND_ROWS * from doctors where #{sql} order by #{params[:sidx]} #{params[:sord]} limit #{noOfRows.to_i*(page.to_i-1)},#{noOfRows.to_i}")
          @total=0
          # records = Doctor.find_by_sql("SELECT FOUND_ROWS() as rows_count")
          # records = records[0].rows_count
          # records = Doctor.select("id").where(sql).count
          records = Doctor.select("count(id) as rows_count").where(sql)
          records = records[0].rows_count
          if !noOfRows.nil?
            if records%noOfRows.to_i == 0
              @total = records/noOfRows.to_i
            else
              @total = (records/noOfRows.to_i)+1
            end
          end
          if page.to_i>@total.to_i
            page = 1
          end
          @doctors = Doctor.where(sql).order("#{params[:sidx]} #{params[:sord]}").limit(noOfRows.to_i).offset(noOfRows.to_i*(page.to_i-1))
          # if !@doctors.empty?
          #   @doctors.each do |doc|
          #     if (doc.province_name.nil? || doc.province_name == '') && !doc.province2.nil?
          #       doc.update(province_name: doc.province2.name)
          #     end
          #     if (doc.city_name.nil? || doc.city_name == '') && !doc.city.nil?
          #       doc.update(city_name: doc.city.name)
          #     end
          #     if (doc.hospital_name.nil? || doc.hospital_name == '')&& !doc.hospital.nil?
          #       doc.update(hospital_name: doc.hospital.name)
          #     end
          #     if (doc.department_name.nil? || doc.department_name == '') && !doc.department.nil?
          #       doc.update(department_name: doc.department.name)
          #     end
          #   end
          # end
          @rows=@doctors #.as_json(:include => [{:hospital => {:only => [:id, :name]}},{:department => {:only => [:id, :name]}}])
    end

    @objJSON = {total:@total,doctors:@rows,page:page,records:records}

    render :json => @objJSON.as_json
  end

  def show_oth_doc
    # hos_id = current_user.hospital_id
    # dep_id = current_user.department_id
    noOfRows = params[:rows]
    page = params[:page]
    sql = 'true'
    # if !hos_id.nil? && hos_id != ''
    #   @hos = Hospital.find(hos_id)
    #   sql << " and (hospital_id = #{hos_id} or hospital_name like '%#{@hos.name}%')"
    # end
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
    @total=0
    # records = Doctor.find_by_sql("SELECT FOUND_ROWS() as rows_count")
    # records = records[0].rows_count
    # records = Doctor.select("id").where(sql).count
    records = Doctor.select("count(id) as rows_count").where(sql)
    records = records[0].rows_count
    if !noOfRows.nil?
      if records%noOfRows.to_i == 0
        @total = records/noOfRows.to_i
      else
        @total = (records/noOfRows.to_i)+1
      end
    end
    if page.to_i>@total.to_i
      page = 1
    end
    @doctors = Doctor.where(sql).order("#{params[:sidx]} #{params[:sord]}").limit(noOfRows.to_i).offset(noOfRows.to_i*(page.to_i-1))
    @rows=@doctors#.as_json(:include => [{:hospital => {:only => [:id, :name]}},{:department => {:only => [:id, :name]}}])
    @objJSON = {total:@total,doctors:@rows,page:page,records:records}

    render :json => @objJSON.as_json
  end

  #获取首页面上医生的显示信息
  def get_doctor_to_page
    @doctor = Doctor.find(params[:id])
    if !@doctor.photo.nil? && @doctor.photo != ''
      if aliyun_file_exit("avatar/#{@doctor.photo.strip}" , Settings.aliyunOSS.image_bucket) || aliyun_file_exit("avatar/#{@doctor.photo}", Settings.aliyunOSS.image_bucket)
        @doctor.photo = Settings.aliyunOSS.photo_url + @doctor.photo
      else
        @doctor.photo = 'http://mimas-img.oss-cn-beijing.aliyuncs.com/352460d5-f56c-4439-99a1-0c17f8964e41.png'
      end
    else
      @doctor.photo = 'http://mimas-img.oss-cn-beijing.aliyuncs.com/352460d5-f56c-4439-99a1-0c17f8964e41.png' #默认图片
    end

    if @doctor
      render :json => {:success => true, :doctor => @doctor.as_json(:include => [{:hospital => {:only => [:id, :name]}}, {:department => {:only => [:id, :name]}}])}
    else
      render :json => {:success => false}
    end

  end

  # GET /doctors/1
  # GET /doctors/1.json
  def show
  end

  # GET /doctors/new
  def new
    hos_id = current_user.hospital_id
    dep_id = current_user.department_id
    if !hos_id.nil? && hos_id != ''
      @hospitals = Hospital.select("id","name").where(id:hos_id)
      if !dep_id.nil? && dep_id != ''
        @departments = Department.select("id","name").where(id:dep_id)
      else
        @departments = Department.select("id","name").where(hospital_id:hos_id)
      end
    else
      @hospitals = Hospital.select("id","name").all
    end
    @doctor = Doctor.new
    photo=@doctor.photo
    default_access_url_prefix = Settings.aliyunOSS.photo_url
    if photo.nil?||photo==''||!aliyun_file_exit('avatar/'+photo,Settings.aliyunOSS.image_bucket)
      photo='/default.png'
    else
      photo= default_access_url_prefix + photo
    end
    @my_photo = photo
    render partial: 'doctors/doctor_form'
  end

  # GET /doctors/1/edit
  def edit
    hos_id = current_user.hospital_id
    dep_id = current_user.department_id
    if !hos_id.nil? && hos_id != ''
      @hospitals = Hospital.select("id","name").where(id:hos_id)
      if !dep_id.nil? && dep_id != ''
        @departments = Department.select("id","name").where(id:dep_id)
      else
        @departments = Department.select("id","name").where(hospital_id:hos_id)
      end
    else
      @hospitals = Hospital.select("id","name").all
      @departments = Department.select("id","name","hospital_id").all
    end
    @doctor = Doctor.where(id:params[:id]).first
    photo=@doctor.photo
    default_access_url_prefix = Settings.aliyunOSS.photo_url
    if photo.nil?||photo==''||!aliyun_file_exit('avatar/'+photo,Settings.aliyunOSS.image_bucket)
      photo='/default.png'
    else
      photo= default_access_url_prefix + photo
    end
    @my_photo = photo
    p @my_photo
    p @doctor
    render partial: 'doctors/doctor_form'
  end

  # POST /doctors
  # POST /doctors.json
  def create
    @hospital = Hospital.where(id:params[:doctor][:hospital_id]).first
    @department = Department.where(id:params[:doctor][:department_id]).first
    @province = Province.where(id:params[:doctor][:province_id]).first
    @city = City.where(id:params[:doctor][:city_id]).first
    if !@hospital.nil?
      params[:doctor][:hospital_name] = @hospital.name
    end
    if !@department.nil?
      params[:doctor][:department_name] = @department.name
    end
    if !@province.nil?
      params[:doctor][:province_name] = @province.name
    end
    if !@city.nil?
      params[:doctor][:city_name] = @city.name
    end
    sql = 'false'
    if params[:doctor][:email] && params[:doctor][:email] != ''
      sql << " or email = '#{params[:doctor][:email]}'"
    end
    if params[:doctor][:mobile_phone] && params[:doctor][:mobile_phone] != ''
      sql << " or mobile_phone = '#{params[:doctor][:mobile_phone]}'"
    end
    if params[:doctor][:credential_type] == '居民身份证' && params[:doctor][:credential_type_number] && params[:doctor][:credential_type_number] != ''
      sql << " or credential_type_number = '#{params[:doctor][:credential_type_number]}'"
    end
    @sear_doc = Doctor.select("id").where(sql).first
    if @sear_doc.nil? && !params[:doctor][:name].nil? && params[:doctor][:name] != ''
      @doctor = Doctor.new(doctor_params)
      if current_user
        if current_user.admin_type == '机构管理员'
          @doctor.organization_id = current_user.organization_id
        end
      end
      if @doctor.save
        render json:{success:'true',data:@doctor}
      else
        render json:{success:'false',data:'保存失败!'}
      end
    else
      render json:{success:'false',data:'保存失败!'}
    end

    # respond_to do |format|
    #   if @doctor.save
    #     format.html { redirect_to @doctor, notice: 'Doctor was successfully created.' }
    #     format.json { render :show, status: :created, location: @doctor }
    #   else
    #     format.html { render :new }
    #     format.json { render json: @doctor.errors, status: :unprocessable_entity }
    #   end
    # end
  end

  # PATCH/PUT /doctors/1
  # PATCH/PUT /doctors/1.json
  def update
    if params[:doctor][:professional_title] == ''
      params[:doctor][:professional_title] = @doctor.professional_title
    end
    sql = 'false'
    if params[:doctor][:email] && params[:doctor][:email] != ''
      sql << " or email = '#{params[:doctor][:email]}'"
    end
    if params[:doctor][:mobile_phone] && params[:doctor][:mobile_phone] != ''
      sql << " or mobile_phone = '#{params[:doctor][:mobile_phone]}'"
    end
    if params[:doctor][:credential_type] == '居民身份证' && params[:doctor][:credential_type_number] && params[:doctor][:credential_type_number] != ''
      sql << " or credential_type_number = '#{params[:doctor][:credential_type_number]}'"
    end
    @sear_doc = Doctor.select("id").where(sql).first
    if (@sear_doc.nil? || @sear_doc.id.to_i  == @doctor.id.to_i) && !params[:doctor][:name].nil? && params[:doctor][:name] != ''
      if current_user
        if current_user.admin_type == '机构管理员'
          @doctor.organization_id = current_user.organization_id
        end
      end
      if @doctor.update(doctor_params)
        if !@doctor.province2.nil?
          @doctor.update_attributes(province_name: @doctor.province2.name)
        end
        if !@doctor.city.nil?
          @doctor.update_attributes(city_name: @doctor.city.name)
        end
        if !@doctor.hospital.nil?
          @doctor.update_attributes(hospital_name: @doctor.hospital.name)
        end
        if !@doctor.department.nil?
          @doctor.update_attributes(department_name: @doctor.department.name)
        end
        render json:{success:true}
      else
        render json:{success:false}
      end
    else
      render json:{success:false}
    end

    # respond_to do |format|
    #   if @doctor.update(doctor_params)
    #     # format.html { redirect_to @doctor, notice: 'Doctor was successfully updated.' }
    #     format.json { render :show, status: :ok, location: @doctor }
    #   else
    #     format.html { render :edit }
    #     format.json { render json: @doctor.errors, status: :unprocessable_entity }
    #   end
    # end
  end

  # DELETE /doctors/1
  # DELETE /doctors/1.json
  def destroy
    ids = params[:id]
    ids_arr = ids.split(',')
    @doctors = Doctor.where(id:ids_arr)
    if !@doctors.empty?
      @doctors.each do |doc|
        if !doc.nil?
          if current_user.admin_type == '网站管理员'
            if !doc.photo.nil? && doc.photo !='' && aliyun_file_exit('avatar/'+doc.photo,Settings.aliyunOSS.image_bucket)
              deleteFromAliyun('avatar/'+doc.photo,Settings.aliyunOSS.beijing_service,Settings.aliyunOSS.image_bucket)
            end
            doc.destroy
          elsif current_user.admin_type == '医院管理员'
            doc.update_attributes(hospital_id:nil,hospital_name:nil,department_id:nil,department_name:nil)
          elsif current_user.admin_type == '科室管理员'
            doc.update_attributes(department_id:nil,department_name:nil)
          end
        end
      end
    end
    render json:{success:true}
    # @doctor.destroy
    # respond_to do |format|
    #   format.html { redirect_to doctors_url, notice: 'Doctor was successfully destroyed.' }
    #   format.json { head :no_content }
    # end
  end

  def get_department
    if !current_user.department_id.nil? && current_user.department_id != ''
      @departments = Department.select("id","name").where(id:current_user.department_id)
    else
      @departments = Department.select("id","name").where(hospital_id:params[:hospital_id])
    end
    if params[:model_class] == 'patient'
      render partial: 'patients/department_partial'
    else
      render partial: 'doctors/department_partial'
    end
  end

  def get_city
    if !params[:province_id].nil? && params[:province_id] != ''
      @city = City.select("id","name").where(province_id:params[:province_id])
    end
    if params[:model_class] == 'hospital'
      render partial: 'hospitals/city_partial'
    elsif params[:model_class] == 'patient'
      render partial: 'patients/city_partial'
    elsif params[:model_class] == 'department'
      render partial: 'departments/city_partial'
    else
      render partial: 'doctors/city_partial'
    end
  end

  def get_hospital
    if !params[:province_id].nil? && params[:province_id] != '' && params[:province_id]!='undefined'
      if !params[:city_id].nil? && params[:city_id] != '' && params[:city_id]!='undefined'
        @hospitals = Hospital.select("id","name").where(province_id:params[:province_id],city_id:params[:city_id])
      else
        @hospitals = Hospital.select("id","name").where(province_id:params[:province_id])
      end
    else
      if !params[:city_id].nil? && params[:city_id] != '' && params[:city_id]!='undefined'
        @hospitals = Hospital.select("id","name").where(city_id:params[:city_id])
      else
        @hospitals = Hospital.select("id","name").all
      end
    end
    if params[:model_class] == 'department'
      render partial: 'departments/hospital_partial'
    elsif params[:model_class] == 'patient'
      render partial: 'patients/hospital_partial'
    else
      render partial: 'doctors/hospital_partial'
    end
  end

  def send_email
    doc_ids = params[:doc_ids].to_s
    doc_ids_arr=doc_ids.split(',')
    flag=false
    if doc_ids_arr.length > 0
      @doctors = Doctor.where(id:doc_ids_arr,is_activated:0)
      if !@doctors.empty?
        @doctors.each do |doc|
          code=""
          6.times do
            code=code+rand(9).to_s
          end
          p code
          doc.update_attributes(verify_code:code)
          path=''
          param={}
          if !doc.email.nil? && doc.email!=''
            path='/mailers/account_active'
            param={email:doc.email, id:doc.id ,verify_code:doc.verify_code}
          end
          params={:query => param}
          response = HTTParty.post(Settings.mimas+path, params)
          if response['success']==true
            doc.update_attributes(is_checked:1)
            flag=true
            # render :json=> {success:true}
          end
        end
      end
    end
    if flag
      render :json => {success:true}
    else
      render :json => {success:false}
    end
  end

  def send_phone
    doc_ids = params[:doc_ids].to_s
    doc_ids_arr=doc_ids.split(',')
    flag=false
    if doc_ids_arr.length > 0
      @doctors = Doctor.where(id:doc_ids_arr,is_activated:0)
      if !@doctors.empty?
        @doctors.each do |doc|
          code=""
          6.times do
            code=code+rand(9).to_s
          end
          doc.update_attributes(verify_code:code)
          path=''
          param={}
          if !doc.mobile_phone.nil? && doc.mobile_phone!=''
            path='/mobile_app/sms_center/sent'
            param={mobile_phone:doc.mobile_phone, id:doc.id ,verify_code:doc.verify_code}
          end
          params={:query => param}
          response = HTTParty.post(Settings.mimas+path, params)
          if response['flag'] == 0
            doc.update_attributes(is_checked:1)
            flag=true
          end
        end
      end
    # else
    #   @pat = Patient.find_by(id:params[:pat_id])
    #   # @user = User.new(name:PinYin.permlink(@doc.name,'')+random.to_s,password:'123456',doctor_id:@doc.id,email:@doc.email,mobile_phone:@doc.mobile_phone,credential_type_number:@doc.credential_type_number)
    #   # @user.save
    #   # p @user.name
    #   code=""
    #   6.times do
    #     code=code+rand(9).to_s
    #   end
    #   @pat.update_attributes(verify_code:code)
    #   path=''
    #   param={}
    #   if !@pat.mobile_phone.nil? && @pat.mobile_phone!=''
    #     path='/mobile_app/sms_center/sent'
    #     param={mobile_phone:@pat.mobile_phone, id:@pat.id ,verify_code:@pat.verify_code}
    #   end
    #   params={:query => param}
    #   response = HTTParty.post(Settings.mimas+path, params)
    #   if response['flag'] == 0
    #     @pat.update_attributes(is_checked:1)
    #     @patient = Patient.where(is_checked:0)#.paginate(:per_page => 20, :page => params[:page])
    #     render :partial => 'doctors/doc_show'
    #   else
    #     render :json => {success:false}
    #   end
    end
    if flag
      render :json => {success:true}
    else
      render :json => {success:false}
    end
  end

  def search_department
    @departments = Department.where(hospital_id:params[:hos_id])
    if params[:hos_id].nil? || params[:hos_id]==''
      @departments=nil
    end
    if !current_user.department_id.nil? && current_user.department_id != ''
      @departments = Department.where(id:current_user.department_id)
    end
    render partial: 'doctors/search_department'
  end

  def search_hospital
    if !params[:pro_id].nil? && params[:pro_id] != ''
      if !params[:city_id].nil? && params[:city_id] != ''
        @hospitals = Hospital.where(province_id:params[:pro_id],city_id:params[:city_id])
      else
        @hospitals = Hospital.where(province_id:params[:pro_id])
      end
    end
    render partial: 'doctors/search_hospital'
  end

  def search_city
    if !params[:pro_id].nil? && params[:pro_id] != ''
      @cities = City.where(province_id:params[:pro_id])
    end
    render partial: 'doctors/search_city'
  end

  def check_email           #用于页面验证
    @doctor = Doctor.find_by(id:params[:doctor_id])
    email=params[:email]
    @user=Doctor.where('email=?',email)
    p @user
    if !@doctor.nil?
      if @user.empty? || @user.first.id.to_i == params[:doctor_id].to_i
        render json:{success:true,content:'此邮箱可以使用'}
      else
        render json:{success:false,content:'此邮箱已注册'}
      end
    else
      if !@user.empty?
        render json:{success:false,content:'此邮箱已注册'}
      else
        render json:{success:true,content:'此邮箱可以使用'}
      end
    end
  end
  def check_phone      #用于页面验证
    @doctor = Doctor.find_by(id:params[:doctor_id])
    mobile_phone=params[:phone]
    @user=Doctor.where('mobile_phone=?',mobile_phone)
    p @user
    if !@doctor.nil?
      if @user.empty? || @user.first.id.to_i == params[:doctor_id].to_i
        render json:{success:true,content:'电话可以使用'}
      else
        render json:{success:false,content:'此电话已占用'}
      end
    else
      if !@user.empty?
        render json:{success:false,content:'此电话已占用'}
      else
        render json:{success:true,content:'电话可以使用'}
      end
    end
  end
  def check_credential_type_number     #用于页面验证
    @doctor = Doctor.find_by(id:params[:doctor_id])
    credential_type_number = params[:credential_type_number]
    @user=Doctor.where('credential_type_number=?',credential_type_number)
    if !@doctor.nil?
      if @user.empty? || @user.first.id.to_i == params[:doctor_id].to_i
        render json:{success:true,content:'此证件号可以使用'}
      else
        render json:{success:false,content:'此证件号已占用'}
      end
    else
      if !@user.empty?
        render json:{success:false,content:'此证件号已占用'}
      else
        render json:{success:true,content:'此证件号可以使用'}
      end
    end
  end

  def get_organizations
    orgs = {}
    @organizations = Organization.all
    @organizations.each do |org|
      orgs[org.id] = org.name
    end
    render :json => {:organizations => orgs.as_json}
  end

  def get_hospitals
    docs = {}
    # docs[0] = '----请选择----'
    if current_user.admin_type == '医院管理员'
      @hospital = Hospital.find_by(id:current_user.hospital_id)
      if !@hospital.nil?
        docs[@hospital.id] = @hospital.name
      end
    else
      @hospitals = Hospital.select("id","name").all
      @hospitals.each do |hos|
        docs[hos.id] = hos.name
      end
    end
    render :json => {:hospitals => docs.as_json}
  end

  def get_departments
    @departments = Department.select("id","name").all
    if !params[:hospital_id].nil?
      @departments = Department.select("id","name").where(hospital_id:params[:hospital_id])
    end
    docs = {}
    str = ""
    @departments.each do |dep|
      docs[dep.id] = dep.name
      opt = "<option value='#{dep.id}'>#{dep.name}</option>"
      if params[:admin_id] != 'null'
        @admin = Admin2.find_by(id:params[:admin_id])
        if !@admin.nil?
          if @admin.department_id.to_i == dep.id.to_i
            opt = "<option value='#{dep.id}' selected>#{dep.name}</option>"
          end
        end
      end
      str = str + opt
    end
    render text: str
  end

  def matchDoctor
    if !current_user.hospital_id.nil? && current_user.hospital_id != ''
      @hospitals = Hospital.where(id:current_user.hospital_id)
      if !current_user.department_id.nil? && current_user.department_id != ''
        @departments = Department.select("id","name").where(id:current_user.department_id)
      else
        @departments = Department.select("id","name").where(hospital_id:current_user.hospital_id)
      end
    else
      @hospitals = Hospital.select("id","name").all
      # @departments = Department.all
    end
    render partial: 'doctors/matchDoctor'
  end

  def forDoctors
    doc_ids = params[:doc_ids].to_s
    p params[:doc_ids]
    p doc_ids
    doc_ids_arr=doc_ids.split(',')
    p doc_ids_arr
    if doc_ids_arr.length > 0
      @doctors = Doctor.where(id:doc_ids_arr)
      if !@doctors.empty?
        @doctors.each do |doc|
          if params[:hos_id] != ''
            doc.update(hospital_id:params[:hos_id])
            if !doc.hospital.nil?
              doc.update_attributes(:hospital_name => doc.hospital.name)
            end
          end
          if params[:dep_id] != ''
            doc.update(department_id:params[:dep_id])
            if !doc.department.nil?
              doc.update_attributes(:department_name => doc.department.name)
            end
          end
        end
      end
    end
    render json: {success:true}
  end

  def delete_image   #点击取消按钮执行该方法
    @doc = Doctor.where(id:params[:doc_id]).first
    service =   Settings.aliyunOSS.beijing_service
    bucket =  Settings.aliyunOSS.image_bucket
    if !@doc.nil?
      if @doc.photo != params[:image]
        deleteFromAliyun('avatar/'+params[:image],service,bucket) #删除头像
      end
    else
      deleteFromAliyun('avatar/'+params[:image],service,bucket) #删除头像
    end
    render json:{success:true}
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_doctor
      @doctor = Doctor.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def doctor_params
      params.require(:doctor).permit(:id, :name, :credential_type, :spell_code,:credential_type_number, :gender, :birthday,
                                     :birthplace, :province_id, :city_id, :hospital_id, :department_id,:province_name,
                                     :city_name, :hospital_name, :department_name, :address, :nationality, :citizenship,
                                     :photo, :marriage, :mobile_phone, :home_phone, :home_address, :contact, :contact_phone,
                                     :home_postcode, :email, :introduction, :professional_title, :position, :hire_date,
                                     :certificate_number, :expertise, :degree, :graduated_from, :graduated_at, :research_paper,
                                     :wechat, :rewards, :is_checked, :is_activated, :verify_code,:is_public, :patient_id,:doctor_type, :organization_id )
    end
end
