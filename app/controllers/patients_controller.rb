class PatientsController < ApplicationController
  before_filter :signed_in_user
  before_action :set_patient, only: [:show, :edit, :update, :destroy]

  # GET /patients
  # GET /patients.json

  def index
    all_menus
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
    render template:  'patients/patient_manage'
  end

  def show_index
    hos_id = current_user.hospital_id
    dep_id = current_user.department_id
    if !params[:hos_id].nil? && params[:hos_id] != '' && params[:hos_id] != 'undefined'
      hos_id = params[:hos_id]
    end
    if !params[:dep_id].nil? && params[:dep_id] != '' && params[:dep_id] != 'all' && params[:dep_id] != 'undefined'
      dep_id = params[:dep_id]
    end
    p dep_id
    is_activated = params[:is_activated]
    is_public = params[:is_public]
    noOfRows = params[:rows]
    page = params[:page]
    @patients_all = nil
    sql = 'true'
    if current_user
      if current_user.admin_type == '机构管理员'
        sql << " and organization_id = #{current_user.organization_id}"
      else
        if !hos_id.nil? && hos_id != '' && !dep_id.nil? && dep_id != ''
          sql << " and hospital_id = #{hos_id} and department_id=#{dep_id}"
        elsif !hos_id.nil? && hos_id != ''
          sql << " and hospital_id = #{hos_id}"
        end
      end
    end
    field = params[:searchField]
    p params[:searchOper]
    value = params[:searchString]
    if !field.nil? && field!='' && !value.nil? && value != ''
      if field == 'doctor_type'
        sql << " and doctor_id in (select id from doctors where doctor_type = '#{value}')"
      elsif field == 'doctor_name'
        sql << " and doctor_id in (select id from doctors where name like '%#{value}%')"
      else
        sql << " and #{field} like '%#{value}%'"
      end
    end
    # sql = 'true'
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
    records=0
    @total=0
    records = Patient.select("count(id) as rows_count").where(sql)
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
    @patients = Patient.where(sql).order("#{params[:sidx]} #{params[:sord]}").limit(noOfRows.to_i).offset(noOfRows.to_i*(page.to_i-1))
      @rows=[]
      @rows=@patients.as_json(:include => [{:hospital => {:only => [:id,:name]}},{:department => {:only => [:id,:name]}},{:doctor => {:only => [:id, :name, :doctor_type]}}])
    @objJSON = {total:@total,patients:@rows,page:page,records:records}
    render :json => @objJSON.as_json
  end

  def show_oth_pat
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
    # records = Patient.find_by_sql("SELECT FOUND_ROWS() as rows_count")
    # records = records[0].rows_count
    # records = Patient.select("id").where(sql).count
    records = Patient.select("count(id) as rows_count").where(sql)
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
    @patients = Patient.where(sql).order("#{params[:sidx]} #{params[:sord]}").limit(noOfRows.to_i).offset(noOfRows.to_i*(page.to_i-1))
    @rows=@patients.as_json(:include => [{:hospital => {:only => [:id, :name]}},{:department => {:only => [:id, :name]}},{:doctor => {:only => [:id, :name]}}])
    @objJSON = {total:@total,patients:@rows,page:page,records:records}

    render :json => @objJSON.as_json
  end


  def show
  end

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
    @patient = Patient.new
    photo=@patient.photo
    default_access_url_prefix = Settings.aliyunOSS.photo_url
    if photo.nil?||photo==''||!aliyun_file_exit('avatar/'+photo,Settings.aliyunOSS.image_bucket)
      photo='/default.png'
    else
      photo= default_access_url_prefix + photo
    end
    @my_photo = photo
    render partial: 'patients/patient_form'
  end

  # GET /patients/1/edit
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
    end
    @patient = Patient.where(id:params[:id]).first
    photo=@patient.photo
    default_access_url_prefix = Settings.aliyunOSS.photo_url
    if photo.nil?||photo==''||!aliyun_file_exit('avatar/'+photo,Settings.aliyunOSS.image_bucket)
      photo='/default.png'
    else
      photo= default_access_url_prefix + photo
    end
    @my_photo = photo
    render partial: 'patients/patient_form'
  end

  # POST /patients
  # POST /patients.json
  def create
    sql = 'false'
    if params[:patient][:email] && params[:patient][:email] != ''
      sql << " or email = '#{params[:patient][:email]}'"
    end
    if params[:patient][:mobile_phone] && params[:patient][:mobile_phone] != ''
      sql << " or mobile_phone = '#{params[:patient][:mobile_phone]}'"
    end
    if params[:patient][:credential_type] == '居民身份证' && params[:patient][:credential_type_number] && params[:patient][:credential_type_number] != ''
      sql << " or credential_type_number = '#{params[:patient][:credential_type_number]}'"
    end
    @sear_pat = Patient.select("id").where(sql).first
    if @sear_pat.nil? && !params[:patient][:name].nil? && params[:patient][:name] != ''
      @patient = Patient.new(patient_params)
      if current_user
        if current_user.admin_type == '机构管理员'
          @patient.organization_id = current_user.organization_id
        end
      end
      # render json:{success:true,data:@patient}
      if @patient.save
        render json: {success:true,data:@patient}
      else
        render json: {success:false,data:'保存失败.'}
      end
    else
      render json: {success:false,data:'保存失败.'}
    end
    # respond_to do |format|
    #   if @patient.save
    #     # format.html { redirect_to @patient, notice: 'Patient was successfully created.' }
    #     format.json { render json:{success:'保存成功'} }
    #   else
    #     # format.html { render :new }
    #     format.json { render json: @patient.errors, status: :unprocessable_entity }
    #   end
    # end
  end

  # PATCH/PUT /patients/1
  # PATCH/PUT /patients/1.json
  def update
    sql = 'false'
    if params[:patient][:email] && params[:patient][:email] != ''
      sql << " or email = '#{params[:patient][:email]}'"
    end
    if params[:patient][:mobile_phone] && params[:patient][:mobile_phone] != ''
      sql << " or mobile_phone = '#{params[:patient][:mobile_phone]}'"
    end
    if params[:patient][:credential_type] == '居民身份证' && params[:patient][:credential_type_number] && params[:patient][:credential_type_number] != ''
      sql << " or credential_type_number = '#{params[:patient][:credential_type_number]}'"
    end
    @sear_pat = Patient.select("id").where(sql).first
    if (@sear_pat.nil? || @sear_pat.id.to_i == @patient.id.to_i) && !params[:patient][:name].nil? && params[:patient][:name] != ''
      if current_user
        if current_user.admin_type == '机构管理员'
          @patient.organization_id = current_user.organization_id
        end
      end
      if @patient.update(patient_params)
        update_doc2user(@patient)
        render json:{success:true}
      else
        render json:{success:false}
      end
    else
      render json:{success:false}
    end
    # respond_to do |format|
    #   if @patient.update(patient_params)
    #     format.html { redirect_to @patient, notice: 'Patient was successfully updated.' }
    #     format.json { render :show, status: :ok, location: @patient }
    #   else
    #     format.html { render :edit }
    #     format.json { render json: @patient.errors, status: :unprocessable_entity }
    #   end
    # end
  end

  #患者信息更新时对应的医生和用户信息也应更改.
  def update_doc2user(patient)
    @doctor = Doctor.where(:patient_id => patient.id).first
    if @doctor
      @doctor.update_attributes(:name => patient.name, :credential_type => patient.credential_type, :credential_type_number => patient.credential_type_number, :gender => patient.gender,
                                :birthday => patient.birthday, :birthplace => patient.birthplace, :province_id => patient.province_id, :city_id => patient.city_id, :hospital_id => patient.hospital_id,
                                :department_id => patient.department_id, :address => patient.address, :nationality => patient.nationality, :citizenship => patient.citizenship, :photo => patient.photo,
                                :marriage => patient.marriage, :mobile_phone => patient.mobile_phone, :home_phone => patient.home_phone, :home_address => patient.home_address, :contact => patient.contact,
                                :contact_phone => patient.contact_phone, :home_postcode => patient.home_postcode, :email => patient.email, :introduction => patient.introduction, :verify_code => patient.verify_code,
                                :is_checked => patient.is_checked, :is_activated => patient.is_activated, :is_public => patient.is_public, :spell_code => patient.spell_code, :province_name => patient.province, :organization_id => patient.organization_id)

    end
    @user = User.where(:patient_id => patient.id).first
    if @user
      @user.update_attributes(:real_name => patient.name, :mobile_phone => patient.mobile_phone, :email => patient.email, :credential_type_number => patient.credential_type_number)
    end
  end

  # DELETE /patients/1
  # DELETE /patients/1.json
  def destroy
    ids = params[:id]
    ids_arr = ids.split(',')
    @patients = Patient.where(id:ids_arr)
    if !@patients.empty?
      @patients.each do |pat|
        if !pat.nil?
          if current_user.admin_type == '网站管理员'
            if !pat.photo.nil? && pat.photo != '' && aliyun_file_exit('avatar/'+pat.photo,Settings.aliyunOSS.image_bucket)
              deleteFromAliyun('avatar/'+pat.photo,Settings.aliyunOSS.beijing_service,Settings.aliyunOSS.image_bucket)
            end
            pat.destroy
          elsif current_user.admin_type == '医院管理员'
            pat.update_attributes(hospital_id:nil,department_id:nil)
          elsif current_user.admin_type == '科室管理员'
            pat.update_attributes(department_id:nil)
          end
        end
      end
    end
    render json:{success:true}
    # @patient.destroy
    # respond_to do |format|
    #   format.html { redirect_to patients_url, notice: 'Patient was successfully destroyed.' }
    #   format.json { head :no_content }
    # end
  end

  def send_email
    pat_ids = params[:pat_ids].to_s
    pat_ids_arr=pat_ids.split(',')
    flag=false
    if pat_ids_arr.length > 0
      @patients = Patient.where(id:pat_ids_arr,is_activated:0)
      if !@patients.empty?
        @patients.each do |pat|
          code=""
          6.times do
            code=code+rand(9).to_s
          end
          p code
          pat.update_attributes(verify_code:code)
          path=''
          param={}
          if !pat.email.nil? && pat.email!=''
            path='/mailers/account_active'
            param={email:pat.email, id:pat.id ,verify_code:pat.verify_code}
          end
          params={:query => param}
          response = HTTParty.post(Settings.mimas+path, params)
          if response['success']==true
            pat.update_attributes(is_checked:1)
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
    pat_ids = params[:pat_ids].to_s
    pat_ids_arr=pat_ids.split(',')
    flag=false
    if pat_ids_arr.length > 0
      @patients = Patient.where(id:pat_ids_arr,is_activated:0)
      if !@patients.empty?
        @patients.each do |pat|
          code=""
          6.times do
            code=code+rand(9).to_s
          end
          pat.update_attributes(verify_code:code)
          path=''
          param={}
          if !pat.mobile_phone.nil? && pat.mobile_phone!=''
            path='/mobile_app/sms_center/sent'
            param={mobile_phone:pat.mobile_phone, id:pat.id ,verify_code:pat.verify_code}
          end
          params={:query => param}
          response = HTTParty.post(Settings.mimas+path, params)
          if response['flag'] == 0
            pat.update_attributes(is_checked:1)
            flag=true
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

  def search_department
    @departments = Department.where(hospital_id:params[:hos_id])
    if !current_user.department_id.nil? && current_user.department_id != ''
      @departments = Department.where(id:current_user.department_id)
    end
    render partial: 'patients/search_department'
  end

  def check_email          #用于页面验证
    @patient = Patient.find_by(id:params[:patient_id])
    email=params[:email]
    @user=Patient.where('email=?',email)
    if !@patient.nil?
      if @user.empty? || @user.first.id.to_i == params[:patient_id].to_i
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
  def check_phone           #用于页面验证
    @patient = Patient.find_by(id:params[:patient_id])
    mobile_phone=params[:phone]
    @user=Patient.where('mobile_phone=?',mobile_phone)
    p @user
    if !@patient.nil?
      if @user.empty? || @user.first.id.to_i == params[:patient_id].to_i
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
  def check_credential_type_number          #用于页面验证
    @patient = Patient.find_by(id:params[:patient_id])
    credential_type_number = params[:credential_type_number]
    @user=Patient.where('credential_type_number=?',credential_type_number)
    if !@patient.nil?
      if @user.empty? || @user.first.id.to_i == params[:patient_id].to_i
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

  def matchPatient
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
    render partial: 'patients/matchPatient'
  end

  def forPatients
    pat_ids = params[:pat_ids].to_s
    p params[:pat_ids]
    p pat_ids
    pat_ids_arr=pat_ids.split(',')
    p pat_ids_arr
    if pat_ids_arr.length > 0
      @patients = Patient.where(id:pat_ids_arr)
      if !@patients.empty?
        @patients.each do |pat|
          if params[:hos_id] != ''
            pat.update(hospital_id:params[:hos_id])
            # if !pat.hospital.nil?
            #   pat.update_attributes(:hospital_name => pat.hospital.name)
            # end
          end
          if params[:dep_id] != ''
            pat.update(department_id:params[:dep_id])
            # if !pat.department.nil?
            #   pat.update_attributes(:department_name => pat.department.name)
            # end
          end
        end
      end
    end
    render json: {success:true}
  end

  def delete_image     #点击取消按钮执行该方法
    @pat = Patient.where(id:params[:pat_id]).first
    service = Settings.aliyunOSS.beijing_service
    bucket =  Settings.aliyunOSS.image_bucket
    if !@pat.nil?
      if @pat.photo != params[:image]
        deleteFromAliyun('avatar/'+params[:image],service,bucket) #删除修改时未保存的头像
      end
    else
      deleteFromAliyun('avatar/'+params[:image],service,bucket) #删除创建时未保存的头像
    end
    render json:{success:true}
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_patient
      @patient = Patient.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def patient_params
      params.require(:patient).permit(:id, :name, :spell_code, :credential_type, :credential_type_number, :gender, :birthday, :birthplace, :address, :nationality, :citizenship, :province, :county, :photo, :marriage, :mobile_phone, :home_phone, :home_address, :contact, :contact_phone, :home_postcode, :email, :introduction, :patient_ids, :education, :household, :occupation, :orgnization, :orgnization_address, :insurance_type, :insurance_number, :doctor_id, :p_user_id, :wechat, :last_treat_time, :diseases_type, :is_public, :childbirth_date, :scan_code, :height, :verify_code, :is_activated, :is_checked, :verify_code_prit_count, :province_id, :city_id ,:hospital_id,:department_id,:organization_id)
    end
end
