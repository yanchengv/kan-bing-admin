class PatientsController < ApplicationController
  before_action :set_patient, only: [:show, :edit, :update, :destroy]

  # GET /patients
  # GET /patients.json
  # def index
  #   # @patients = Patient.all
  #   noOfRows = params[:rows]
  #   page = params[:page]
  #   @menu_id = params[:menu_id]
  #   @patients_all=nil
  #   if params[:menu_id]
  #     menu_permission = MenuPermission.where(menu_id:params[:menu_id],admin2_id:current_user.id)
  #     # menu_permission_dep = MenuPermission.where(menu_id:params[:menu_id],admin2_id:current_user.id)
  #     menu_permission_hos_id=[]
  #     menu_permission_dep_id=[]
  #     menu_permission.each do |hos|
  #       if !hos.hospital_id.nil?
  #         p menu_permission_hos_id
  #         menu_permission_hos_id.concat(hos.hospital_id.split(","))
  #       end
  #       if !hos.department_id.nil?
  #         menu_permission_dep_id.concat(hos.department_id.split(","))
  #       end
  #     end
  #     # menu_permission_dep.each do |dep|
  #     #   menu_permission_dep_id.concat(dep.hospital_id.split(","))
  #     # end
  #     p menu_permission_hos_id
  #     p menu_permission_dep_id
  #     if menu_permission_dep_id != []
  #       if menu_permission_hos_id != []
  #         sql="hospital_id in (#{menu_permission_hos_id.join(",")}) or department_id in (#{menu_permission_dep_id.join(",")})"
  #         @patients_all = Patient.where(sql).distinct!
  #       else
  #         @patients_all = Patient.where(department_id:menu_permission_dep_id)
  #       end
  #     else
  #       if !menu_permission_hos_id.nil? && menu_permission_hos_id != []
  #         @patients_all = Patient.where(hospital_id:menu_permission_hos_id)
  #       else
  #         @patients_all = Patient.all
  #       end
  #     end
  #   else
  #     @patients_all = Patient.all
  #   end
  #   records=0
  #   @total=0
  #   if !@patients_all.nil? && !@patients_all.empty?
  #     # "searchField"=>"name", "searchString"=>"张", "searchOper"=>"bw", "filters"=>""
  #     records = @patients_all.length
  #     @patients = @patients_all.paginate(:per_page => noOfRows, :page => page)
  #     if !noOfRows.nil?
  #       if records%noOfRows.to_i == 0
  #         @total = records/noOfRows.to_i
  #       else
  #         @total = (records/noOfRows.to_i)+1
  #       end
  #     end
  #     @rows=[]
  #     @patients.each do |pat|
  #       @province=Province.where(id:pat.province_id).first
  #       @city=City.where(id:pat.city_id).first
  #       @hospital=Hospital.where(id:pat.hospital_id).first
  #       @department=Department.where(id:pat.department_id).first
  #
  #
  #       @province.nil? ? province_name='':province_name=@province.name
  #       @city.nil? ? city_name='':city_name=@city.name
  #       @hospital.nil? ? hospital_name='':hospital_name=@hospital.name
  #       @department.nil? ? department_name='':department_name=@department.name
  #       a={id:pat.id,
  #          cell:[
  #              # pat.id,
  #              pat.name,
  #              pat.credential_type,
  #              pat.credential_type_number,
  #              pat.gender,
  #              pat.birthday,
  #              pat.birthplace,
  #              # pat.province_id,
  #              # pat.city_id,
  #              # pat.hospital_id,
  #              # pat.department_id,
  #              province_name,
  #              city_name,
  #              hospital_name,
  #              department_name,
  #              pat.mobile_phone,
  #              pat.email,
  #              pat.last_treat_time,
  #              pat.introduction
  #          ]
  #       }
  #       @rows.push(a)
  #     end
  #   end
  #   @objJSON = {total:@total,rows:@rows,page:page,records:records}
  #   @objJSON.as_json
  # end

  def index
      # @patients = Patient.all
    hos_id = params[:hos_id]
    dep_id = params[:dep_id]
    is_activated = params[:is_activated]
      noOfRows = params[:rows]
      page = params[:page]
      @menu_id = params[:menu_id]
      @patients_all = nil
      if !hos_id.nil? && hos_id != '' && !dep_id.nil? && dep_id != ''
        @patients_all = Patient.where(hospital_id:hos_id,department_id:dep_id)
      elsif !hos_id.nil? && hos_id != ''
        @patients_all = Patient.where(hospital_id:hos_id)
      else
        @patients_all = Patient.all
      end
      if is_activated=='0'
        @patients_all =  @patients_all.where(is_activated:0)
      end
      if is_activated=='1'
        @patients_all =  @patients_all.where.not(is_activated:0)
      end
      records=0
      @total=0
      if !@patients_all.nil? && !@patients_all.empty?
        # "searchField"=>"name", "searchString"=>"张", "searchOper"=>"bw", "filters"=>""
        records = @patients_all.length
        @patients = @patients_all.paginate(:per_page => noOfRows, :page => page)
        if !noOfRows.nil?
          if records%noOfRows.to_i == 0
            @total = records/noOfRows.to_i
          else
            @total = (records/noOfRows.to_i)+1
          end
        end
        @rows=[]
        @patients.each do |pat|
          @province=Province.where(id:pat.province_id).first
          @city=City.where(id:pat.city_id).first
          @hospital=Hospital.where(id:pat.hospital_id).first
          @department=Department.where(id:pat.department_id).first


          @province.nil? ? province_name='':province_name=@province.name
          @city.nil? ? city_name='':city_name=@city.name
          @hospital.nil? ? hospital_name='':hospital_name=@hospital.name
          @department.nil? ? department_name='':department_name=@department.name
          a={id:pat.id,
             cell:[
                 # pat.id,
                 pat.name,
                 pat.credential_type,
                 pat.credential_type_number,
                 pat.gender,
                 pat.birthday,
                 pat.birthplace,
                 # pat.province_id,
                 # pat.city_id,
                 # pat.hospital_id,
                 # pat.department_id,
                 province_name,
                 city_name,
                 hospital_name,
                 department_name,
                 pat.mobile_phone,
                 pat.email,
                 pat.last_treat_time,
                 pat.introduction
             ]
          }
          @rows.push(a)
        end
      end
      @objJSON = {total:@total,rows:@rows,page:page,records:records}
      @objJSON.as_json
  end
  # GET /patients/1
  # GET /patients/1.json
  def show
  end

  # GET /patients/new
  def new
    @menu_id = params[:menu_id]
    @patient = Patient.new
    render partial: 'patients/form'
  end

  # GET /patients/1/edit
  def edit
    @menu_id = params[:menu_id]
    @patient = Patient.where(id:params[:id]).first
    render partial: 'patients/form'
  end

  # POST /patients
  # POST /patients.json
  def create
    @patient = Patient.new(patient_params)
    # render json:{success:true,data:@patient}

    respond_to do |format|
      if @patient.save
        # format.html { redirect_to @patient, notice: 'Patient was successfully created.' }
        format.json { render json:{success:'保存成功'} }
      else
        # format.html { render :new }
        format.json { render json: @patient.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /patients/1
  # PATCH/PUT /patients/1.json
  def update
    if @patient.update(patient_params)
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

  def is_executable
    @menu_permissions = MenuPermission.where(menu_id: params[:menu_id], admin2_id: current_user.id)
    ids = params[:id].to_s
    p ids
    ids_arr = ids.split(',')
    @patient=nil
    @patients=nil
    if ids_arr != []
      if ids_arr.length == 1
        @patient = Patient.where(id:ids_arr).first
      else
        @patients = Patient.where(id:ids_arr)
      end
      # @patient = Patient.where(id:ids_arr)
      is_manage=false
      is_add=false
      is_show=false
      is_edit=false
      is_delete=false
      is_activated=true
      if !@menu_permissions.empty? && !@patient.nil?
        p 'patient'
        @menu_permissions.each do |menu_per|
          if !menu_per.hospital_id.nil? && !menu_per.hospital_id.split(",").index(@patient.hospital_id.to_s).nil?
            flag=false
            if is_manage == false
              is_manage = menu_per.is_manage
            end
            if is_show == false
              is_show = menu_per.is_show
            end
            if is_add == false
              is_add = menu_per.is_add
            end
            if is_edit == false
              is_edit = menu_per.is_edit
            end
            if is_delete == false
              is_delete = menu_per.is_delete
            end
          end
          if !menu_per.department_id.nil? &&  !menu_per.department_id.split(",").index(@patient.department_id.to_s).nil?
            flag=false
            if is_manage == false
              is_manage = menu_per.is_manage
            end
            if is_show == false
              is_show = menu_per.is_show
            end
            if is_add == false
              is_add = menu_per.is_add
            end
            if is_edit == false
              is_edit = menu_per.is_edit
            end
            if is_delete == false
              is_delete = menu_per.is_delete
            end
          end
          if menu_per.department_id.nil? && menu_per.hospital_id.nil?
            if is_manage == false
              is_manage = menu_per.is_manage
            end
            if is_show == false
              is_show = menu_per.is_show
            end
            if is_add == false
              is_add = menu_per.is_add
            end
            if is_edit == false
              is_edit = menu_per.is_edit
            end
            if is_delete == false
              is_delete = menu_per.is_delete
            end
          end
        end
        if @patient.is_activated == 1
          is_activated=false
        end
      end
      if !@menu_permissions.empty? && !@patients.nil? && !@patients.empty?
        p 'patients'
        is_m=true
        is_s=true
        is_d=true
        @menu_permissions.each do |menu_per|
          if menu_per.department_id.nil? && menu_per.hospital_id.nil?
            if is_manage == false
              is_manage = menu_per.is_manage
            end
            if is_show == false
              is_show = menu_per.is_show
            end
            if is_delete == false
              is_delete = menu_per.is_delete
            end
          end
          @patients.each do |patient|
            if !menu_per.hospital_id.nil? && !menu_per.hospital_id.split(",").index(patient.hospital_id.to_s).nil?
              if is_m
                is_m = menu_per.is_manage
              end
              if is_s
                is_s = menu_per.is_show
              end
              if is_d
                is_d = menu_per.is_delete
              end
            end
            if !menu_per.department_id.nil? &&  !menu_per.department_id.split(",").index(patient.department_id.to_s).nil?
              if is_m
                is_m = menu_per.is_manage
              end
              if is_s
                is_s = menu_per.is_show
              end
              if is_d
                is_d = menu_per.is_delete
              end
            end
            if patient.is_activated == 1
              is_activated=false
            end
          end
          p is_d
          p is_m
          p 'i'
          if !menu_per.department_id.nil? || !menu_per.hospital_id.nil?
            if is_manage == false
              is_manage=is_m
            end
            if is_show == false
              is_show=is_s
            end
            if is_show == false
              is_show=is_m
            end
          end
        end
        is_edit=false
        is_add=true
      end
    end
    p 'end'
    p is_delete
    p is_manage
    render json:{is_add:is_add,is_delete:is_delete,is_show:is_show,is_edit:is_edit,is_manage:is_manage,is_activated:is_activated}
  end

  def send_email
    pat_ids = params[:pat_ids].to_s
    pat_ids_arr=pat_ids.split(',')
    flag=false
    if pat_ids_arr.length > 0
      @patients = Patient.where(id:pat_ids_arr)
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
      @patients = Patient.where(id:pat_ids_arr)
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
    render partial: 'patients/search_department'
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
