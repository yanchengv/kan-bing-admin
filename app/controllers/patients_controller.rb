class PatientsController < ApplicationController
  before_filter :signed_in_user
  before_action :set_patient, only: [:show, :edit, :update, :destroy]

  # GET /patients
  # GET /patients.json

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
    render partial: 'patients/patient_manage'
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
    if !hos_id.nil? && hos_id != '' && !dep_id.nil? && dep_id != ''
      sql << " and hospital_id = #{hos_id} and department_id=#{dep_id}"
    elsif !hos_id.nil? && hos_id != ''
      sql << " and hospital_id = #{hos_id}"
    end
    # field = params[:searchField]
    # p params[:searchOper]
    # value = params[:searchString]
    # if !field.nil? && field!='' && !value.nil?
    #   sql << "#{field} like ''%#{value}%''")
    # end
    # sql = 'true'
    if params[:name] && params[:name] != ''
      sql << " and name like '%#{params[:name]}%' or spell_code like '%#{params[:name]}%'"
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
    @patients = Patient.where(sql).order("#{params[:sidx]} #{params[:sord]}").limit(noOfRows.to_i).offset(noOfRows.to_i*(page.to_i-1))
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
      @rows=[]
      @rows=@patients.as_json(:include => [{:hospital => {:only => [:id,:name]}},{:department => {:only => [:id,:name]}}])
    @objJSON = {total:@total,patients:@rows,page:page,records:records}
    render :json => @objJSON.as_json
  end

  def show
  end

  def new
    hos_id = current_user.hospital_id
    dep_id = current_user.department_id
    if !hos_id.nil? && hos_id != ''
      @hospitals = Hospital.where(id:hos_id)
      if !dep_id.nil? && dep_id != ''
        @departments = Department.where(id:dep_id)
      else
        @departments = Department.where(hospital_id:hos_id)
      end
    else
      @hospitals = Hospital.all
    end
    @patient = Patient.new
    photo=@patient.photo
    default_access_url_prefix = Settings.aliyunOSS.photo_url
    if photo.nil?||photo==''
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
      @hospitals = Hospital.where(id:hos_id)
      if !dep_id.nil? && dep_id != ''
        @departments = Department.where(id:dep_id)
      else
        @departments = Department.where(hospital_id:hos_id)
      end
    else
      @hospitals = Hospital.all
    end
    @patient = Patient.where(id:params[:id]).first
    photo=@patient.photo
    default_access_url_prefix = Settings.aliyunOSS.photo_url
    if photo.nil?||photo==''
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
    @hospital = Hospital.where(id:params[:patient][:hospital_id]).first
    @department = Department.where(id:params[:patient][:department_id]).first
    @province = Province.where(id:params[:patient][:province_id]).first
    @city = City.where(id:params[:patient][:city_id]).first
    if !@hospital.nil?
      params[:patient][:hospital_name] = @hospital.name
    end
    if !@department.nil?
      params[:patient][:department_name] = @department.name
    end
    if !@province.nil?
      params[:patient][:province_name] = @province.name
    end
    if !@city.nil?
      params[:patient][:city_name] = @city.name
    end
    @patient = Patient.new(patient_params)
    # render json:{success:true,data:@patient}
    if @patient.save
      render json: {success:true,data:@patient}
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
    if params[:patient][:professional_title] == ''
      params[:patient][:professional_title] = @patient.professional_title
    end
    if @patient.update(patient_params)
      if !@patient.province2.nil?
        @patient.update_attributes(province_name: @patient.province2.name)
      end
      if !@patient.city.nil?
        @patient.update_attributes(city_name: @patient.city.name)
      end
      if !@patient.hospital.nil?
        @patient.update_attributes(hospital_name: @patient.hospital.name)
      end
      if !@patient.department.nil?
        @patient.update_attributes(department_name: @patient.department.name)
      end
      render json:{success:true}
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

  # DELETE /patients/1
  # DELETE /patients/1.json
  def destroy
    ids = params[:id]
    ids_arr = ids.split(',')
    @patients = Patient.where(id:ids_arr)
    if !@patients.empty?
      @patients.each do |pat|
        if !pat.photo.nil? && pat.photo != ''
          deleteFromAliyun('avatar/'+pat.photo,Settings.aliyunOSS.beijing_service,Settings.aliyunOSS.image_bucket)
        end
        pat.destroy
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
      if !@user.empty? && @patient.email!=email
        render json:{success:false,content:'此邮箱已注册'}
      else
        render json:{success:true,content:'此邮箱可以使用'}
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
      if !@user.empty? && @patient.mobile_phone!=mobile_phone
        render json:{success:false,content:'此电话已占用'}
      else
        render json:{success:true,content:'电话可以使用'}
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
      if !@user.empty? && @patient.credential_type_number!=credential_type_number
        render json:{success:false,content:'此证件号已占用'}
      else
        render json:{success:true,content:'此证件号可以使用'}
      end
    else
      if !@user.empty?
        render json:{success:false,content:'此证件号已占用'}
      else
        render json:{success:true,content:'此证件号可以使用'}
      end
    end
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
      params.require(:patient).permit(:id, :name, :spell_code, :credential_type, :credential_type_number, :gender, :birthday, :birthplace, :address, :nationality, :citizenship, :province, :county, :photo, :marriage, :mobile_phone, :home_phone, :home_address, :contact, :contact_phone, :home_postcode, :email, :introduction, :patient_ids, :education, :household, :occupation, :orgnization, :orgnization_address, :insurance_type, :insurance_number, :doctor_id, :p_user_id, :wechat, :last_treat_time, :diseases_type, :is_public, :childbirth_date, :scan_code, :height, :verify_code, :is_activated, :is_checked, :verify_code_prit_count, :province_id, :city_id ,:hospital_id,:department_id)
    end
end
