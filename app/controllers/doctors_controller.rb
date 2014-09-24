class DoctorsController < ApplicationController
  before_filter :signed_in_user
  before_action :set_doctor, only: [:show, :edit, :update, :destroy]

  # GET /doctors
  # GET /doctors.json
  def index
    # @doctor = Doctor.new
    # @doctors = Doctor.all
    noOfRows = params[:rows]
    page = params[:page]
    @menu_id = params[:menu_id]
    @doctors_all=nil
    if params[:menu_id]
      menu_permission = MenuPermission.where(menu_id:params[:menu_id],admin2_id:current_user.id)
      # menu_permission_dep = MenuPermission.where(menu_id:params[:menu_id],admin2_id:current_user.id)
      menu_permission_hos_id=[]
      menu_permission_dep_id=[]
      menu_permission.each do |hos|
        if !hos.hospital_id.nil?
          p menu_permission_hos_id
          menu_permission_hos_id.concat(hos.hospital_id.split(","))
        end
        if !hos.department_id.nil?
          menu_permission_dep_id.concat(hos.department_id.split(","))
        end
      end
      # menu_permission_dep.each do |dep|
      #   menu_permission_dep_id.concat(dep.hospital_id.split(","))
      # end
      p menu_permission_hos_id
      p menu_permission_dep_id
      if menu_permission_dep_id != []
        if menu_permission_hos_id != []
          sql="hospital_id in (#{menu_permission_hos_id.join(",")}) or department_id in (#{menu_permission_dep_id.join(",")})"
          @doctors_all = Doctor.where(sql).distinct!
          # @doctors = Doctor.where(hospital_id:menu_permission_hos_id,department_id:menu_permission_dep_id)
        else
          @doctors_all = Doctor.where(department_id:menu_permission_dep_id)
        end
      else
        if !menu_permission_hos_id.nil? && menu_permission_hos_id != []
          @doctors_all = Doctor.where(hospital_id:menu_permission_hos_id)
        else
          @doctors_all = Doctor.all
        end
      end
    else
      @doctors_all = Doctor.all
    end
    records = @doctors_all.length
    # @doctors = @doctors_all
    p records
    p noOfRows
    @doctors = @doctors_all.paginate(:per_page => noOfRows, :page => page)
    @total=1
    if !noOfRows.nil?
      if records%noOfRows.to_i == 0
        @total = records/noOfRows.to_i
      else
        @total = (records/noOfRows.to_i)+1
      end
    end
    p @doctors
    @rows=[]
    @doctors.each do |doc|
      a={id:doc.id,
         cell:[
             doc.id,
             doc.name,
             doc.credential_type,
             doc.credential_type_number,
             doc.gender,
             doc.birthday,
             doc.birthplace,
             doc.province_id,
             doc.city_id,
             doc.hospital_id,
             doc.department_id,
             doc.mobile_phone,
             doc.email,
             doc.professional_title,
             doc.introduction
         ]
      }
      @rows.push(a)
    end
    @objJSON = {total:@total,rows:@rows,page:page,records:records}
    # @doctors[0]["total"]=@total

    @objJSON.as_json
    p @objJSON.as_json
  end

  # GET /doctors/1
  # GET /doctors/1.json
  def show
  end

  # GET /doctors/new
  def new
    @doctor = Doctor.new
    render partial: 'doctors/form'
  end

  # GET /doctors/1/edit
  def edit
    @doctor = Doctor.where(id:params[:id]).first
    render partial: 'doctors/form'
  end

  # POST /doctors
  # POST /doctors.json
  def create
    @doctor = Doctor.new(doctor_params)
    render json:{success:true,data:@doctor}
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
    if @doctor.update(doctor_params)
      render json:{success:true}
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
        doc.destroy
      end
    end
    render json:{suceess:true}
    # @doctor.destroy
    # respond_to do |format|
    #   format.html { redirect_to doctors_url, notice: 'Doctor was successfully destroyed.' }
    #   format.json { head :no_content }
    # end
  end

  def get_department
    @department = Department.all
    @hospital_id = nil
    if !params[:province_id].nil? && params[:province_id]!='' && params[:province_id]!='undefined'
      if !params[:city_id].nil? && params[:city_id]!='' && params[:city_id]!='undefined'
        @hospital_id = Hospital.select("id").where(province_id:params[:province_id],city_id:params[:city_id])
      else
        @hospital_id = Hospital.select("id").where(province_id:params[:province_id])
      end
    else
      if !params[:city_id].nil? && params[:city_id]!='' && params[:city_id]!='undefined'
        @hospital_id = Hospital.select("id").where(city_id:params[:city_id])
      else
        @hospital_id = Hospital.all
      end
    end
    if !params[:hospital_id].nil? && params[:hospital_id] != '' && params[:hospital_id]!='undefined'
      @hospital_id =params[:hospital_id]
    end
    if !@hospital_id.nil? || @hospital !=''
      @department = Department.where(hospital_id:@hospital_id)
    end
    # @doctor = Doctor.new
    # @doctor.set_part
    # render json:{success:true,data:@department}
    render partial: 'doctors/department_partial'
  end

  def get_city
    @city = City.all
    if !params[:province_id].nil? && params[:province_id] != ''
      @city = City.where(province_id:params[:province_id])
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
    @hospital = Hospital.all
    if !params[:province_id].nil? && params[:province_id] != '' && params[:province_id]!='undefined'
      if !params[:city_id].nil? && params[:city_id] != '' && params[:city_id]!='undefined'
        @hospital = Hospital.where(province_id:params[:province_id],city_id:params[:city_id])
      else
        @hospital = Hospital.where(province_id:params[:province_id])
      end
    else
      if !params[:city_id].nil? && params[:city_id] != '' && params[:city_id]!='undefined'
        @hospital = Hospital.where(city_id:params[:city_id])
      else
        @hospital = Hospital.all
      end
    end
    if params[:model_class] == 'department'
      render partial: 'departments/hospital_partial'
    else
      render partial: 'doctors/hospital_partial'
    end
  end

  def is_executable
    @menu_permissions = MenuPermission.where(menu_id: params[:menu_id], admin2_id: current_user.id)
    ids = params[:id].to_s
    p ids
    ids_arr = ids.split(',')
    @doctor=nil
    @doctors=nil
    if ids_arr != []
      if ids_arr.length == 1
        @doctor = Doctor.where(id:ids_arr).first
      else
        @doctors = Doctor.where(id:ids_arr)
      end
      # @doctor = Doctor.where(id:ids_arr)
      is_manage=false
      is_add=false
      is_show=false
      is_edit=false
      is_delete=false
      if !@menu_permissions.empty? && !@doctor.nil?
        p 'doctor'
        @menu_permissions.each do |menu_per|
          if !menu_per.hospital_id.nil? && !menu_per.hospital_id.split(",").index(@doctor.hospital_id.to_s).nil?
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
          if !menu_per.department_id.nil? &&  !menu_per.department_id.split(",").index(@doctor.department_id.to_s).nil?
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
      end
      if !@menu_permissions.empty? && !@doctors.nil? && !@doctors.empty?
        p 'doctors'
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
          is_m=true
          is_s=true
          is_d=true
          @doctors.each do |doctor|
            if !menu_per.hospital_id.nil? && !menu_per.hospital_id.split(",").index(doctor.hospital_id.to_s).nil?
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
            if !menu_per.department_id.nil? &&  !menu_per.department_id.split(",").index(doctor.department_id.to_s).nil?
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
          end
          p is_d
          p is_m
          p 'i'
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
        is_edit=false
        is_add=true
      end
    end
    p 'end'
    p is_delete
    p is_manage
    render json:{is_add:is_add,is_delete:is_delete,is_show:is_show,is_edit:is_edit,is_manage:is_manage}
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_doctor
      @doctor = Doctor.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def doctor_params
      params.require(:doctor).permit(:name, :credential_type, :credential_type_number, :gender, :birthday, :birthplace, :province_id, :city_id, :hospital_id, :department_id,:province_name, :city_name, :hospital_name, :department_name, :address, :nationality, :citizenship, :photo, :marriage, :mobile_phone, :home_phone, :home_address, :contact, :contact_phone, :home_postcode, :email, :introduction, :professional_title, :position, :hire_date, :certificate_number, :expertise, :degree, :graduated_from, :graduated_at, :research_paper, :wechat, :rewards)
    end
end
