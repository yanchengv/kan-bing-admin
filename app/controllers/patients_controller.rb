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

  def index2          #含增删改查权限的 ############　删　################
=begin
    menu_name='医院人员'
    @hospitals=Patient.new.manage_patients menu_name
    if !@hospitals.first.nil?
      @hos = Hospital.find_by(id:@hospitals.first.id)
    end
=end
    menu_name='患者管理'
    @hospitals=Patient.new.manage_patients(menu_name,current_user.id)
    @hos = Hospital.find_by(id:params[:hos_id])
    @hos_id = params[:hos_id]
    @menu_id = params[:menu_id]
    @menu = Menu.where(id:@menu_id).first
    # @departments=Department.find_by_sql("select d.id,d.name from departments d,role2s r, menu_permissions mp , admin2s_role2s ar,role2s_menu_permissions rmp, menus where  mp.id=rmp.menu_permission_id and ar.admin2_id=#{current_user.id} and ar.role2_id=r.id and r.id=rmp.role2_id and menus.id=mp.menu_id and menus.parent_id=#{@menu.parent_id} and mp.menu_id=menus.id and d.id=mp.department_id GROUP BY d.id;")
    @departments=Department.find_by_sql("select d.id,d.name from departments d,role2s r, menu_permissions mp , admin2s_role2s ar,role2s_menu_permissions rmp, menus where  mp.id=rmp.menu_permission_id and ar.admin2_id=#{current_user.id} and ar.role2_id=r.id and r.id=rmp.role2_id and menus.id=mp.menu_id and menus.parent_id=#{@menu_id} and mp.menu_id=menus.id and d.id=mp.department_id GROUP BY d.id;")
    if @departments.empty?
      @departments = Department.where(hospital_id:params[:hos_id])
    end
    # @dep = Department.find_by(id:params[:dep_id])
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

  def show_index2                  #含增删改查权限的 ############　删　################
      # @patients = Patient.all
=begin
    menu_name='医院人员'
    @hospitals=Patient.new.manage_patients menu_name
    if !@hospitals.first.nil?
      @hos = Hospital.find_by(id:@hospitals.first.id)
    end
    if !@hospitals.first.nil?
      hos_id = @hospitals.first.id
    end
    if !params[:hos_id].nil?
      hos_id = params[:hos_id]
    end
=end
    @menu_id = params[:menu_id]
    @menu = Menu.find_by(id:@menu_id).parent_menu
    @child_menus = @menu.child_menus
    menu_ids = []
    if !@child_menus.empty?
      @child_menus.each do |child_menu|
        menu_ids.push(child_menu.id)
      end
    end
    # @departments=Department.find_by_sql("select d.id,d.name from departments d,role2s r, menu_permissions mp , admin2s_role2s ar,role2s_menu_permissions rmp, menus where  mp.id=rmp.menu_permission_id and ar.admin2_id=#{current_user.id} and ar.role2_id=r.id and r.id=rmp.role2_id and menus.id=mp.menu_id and menus.parent_id=#{@menu.parent_id} and mp.menu_id=menus.id and d.id=mp.department_id GROUP BY d.id;")
    @departments=Department.find_by_sql("select d.id from departments d,role2s r, menu_permissions mp , admin2s_role2s ar,role2s_menu_permissions rmp, menus where  mp.id=rmp.menu_permission_id and ar.admin2_id=#{current_user.id} and ar.role2_id=r.id and r.id=rmp.role2_id and menus.id=mp.menu_id and menus.parent_id in (#{menu_ids.to_s[1..-2]}) and mp.menu_id=menus.id and d.id=mp.department_id and d.hospital_id=#{params[:hos_id]} GROUP BY d.id;")
    p @departments
    p @departments.empty?
    if @departments.empty?
      dep_id = ''
    end
    priority_ids = params[:priority_ids]
    if !priority_ids.nil?
      # @menu1 = Menu.find_by(id:params[:menu_id])
      # @menu = Menu.find_by_sql("select m.id,m.name from menu_permissions mp,menus m, role2s_menu_permissions rmp, admin2s_role2s ar where mp.menu_id=m.id and rmp.menu_permission_id=mp.id and rmp.role2_id=ar.role2_id and ar.admin2_id=#{current_user.id} and m.parent_id=#{@menu1.parent_id} and mp.hospital_id=#{params[:hos_id]}").first
      @departments=Department.find_by_sql("select d.id from departments d,role2s r, menu_permissions mp , admin2s_role2s ar,role2s_menu_permissions rmp, menus where  mp.id=rmp.menu_permission_id and ar.admin2_id=#{current_user.id} and ar.role2_id=r.id and r.id=rmp.role2_id and menus.id=mp.menu_id and menus.parent_id in (#{menu_ids.to_s[1..-2]}) and mp.menu_id=menus.id and d.id=mp.department_id and d.hospital_id=#{params[:hos_id]} GROUP BY d.id;")
      p @departments
      priority_ids = priority_ids.split(',')
      if priority_ids != []
        priority_ids.each do |priority_id|
          if @departments != []
            @dep = Department.find_by_sql("select d.id,d.name from departments d,menus m, menu_permissions mp, role2s_menu_permissions rmp, admin2s_role2s ar where mp.menu_id=m.id and rmp.menu_permission_id=mp.id and mp.department_id=d.id and rmp.role2_id=ar.role2_id and ar.admin2_id=#{current_user.id} and m.parent_id in (#{menu_ids.to_s[1..-2]}) and mp.hospital_id=#{params[:hos_id]} and mp.priority_id=#{priority_id}")
            if !@last_dep.nil?
              @dep = (@last_dep&@dep)
            end
            @last_dep = @dep
          else
            @hos = MenuPermission.find_by_sql("select mp.menu_id,mp.hospital_id,mp.priority_id from menu_permissions mp,menus m, role2s_menu_permissions rmp, admin2s_role2s ar where mp.menu_id=m.id and rmp.menu_permission_id=mp.id and rmp.role2_id=ar.role2_id and ar.admin2_id=#{current_user.id} and m.parent_id=#{@menu.id} and mp.hospital_id=#{params[:hos_id]} and mp.priority_id=#{priority_id}")
            if !@last_dep.nil?
              if @hos == [] || @last_dep == []
                @last_dep = []
              else
                @last_dep = ''
              end
            else
              if @hos == []
                @last_dep = []
              else
                @last_dep = ''
              end
            end
          end
        end
      end
      if !@last_dep.nil?
        dep_id = @last_dep
      end
    end
    if !params[:hos_id].nil? && params[:hos_id] != ''
      hos_id = params[:hos_id]
    end
    if !params[:dep_id].nil? && params[:dep_id] != ''
      if params[:dep_id] == 'all'
        dep_id = ''
      else
        dep_id = params[:dep_id]
      end
    end
    p dep_id
    is_activated = params[:is_activated]
      noOfRows = params[:rows]
      page = params[:page]
      @menu_id = params[:menu_id]
      @patients_all = nil
      if !hos_id.nil? && hos_id != '' && !dep_id.nil? && dep_id != ''
        @patients_all = Patient.where(hospital_id:hos_id,department_id:dep_id)
      elsif !hos_id.nil? && hos_id != ''
        @patients_all = Patient.where(hospital_id:hos_id)
      # else
      #   @patients_all = Patient.all
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
      render :json => @objJSON.as_json
  end #含增删改查权限的 ############　删　################
  # GET /patients/1
  # GET /patients/1.json
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
    default_access_url_prefix = Settings.aliyunOSS.photo_url#"http://mimas-open.oss-cn-hangzhou.aliyuncs.com/"
    if photo.nil?||photo==''
      photo='/default.png'
    else
      photo= default_access_url_prefix + photo
    end
    @my_photo = photo
    render partial: 'patients/patient_form'
  end

  # GET /patients/new
  def new2    #含增删改查权限的 ############　删　################
    menu_name = '患者管理'
    @menu=Menu.where(name:menu_name).first
    @hos_menus = Menu.find_by_sql("select m.id,m.name,mp.hospital_id as hos_id,mp.priority_id from menu_permissions mp,menus m, role2s_menu_permissions rmp, admin2s_role2s ar where mp.menu_id=m.id and rmp.menu_permission_id=mp.id and rmp.role2_id=ar.role2_id and ar.admin2_id=#{current_user.id} and m.parent_id=#{@menu.id}")
    hos_ids = []
    if !@hos_menus.empty?
      @hos_menus.each do |hos_menu|
        @dep_menu_pers = MenuPermission.find_by_sql("select mp.menu_id,mp.hospital_id,mp.priority_id from menu_permissions mp,menus m, role2s_menu_permissions rmp, admin2s_role2s ar where mp.menu_id=m.id and rmp.menu_permission_id=mp.id and rmp.role2_id=ar.role2_id and ar.admin2_id=#{current_user.id} and m.parent_id=#{hos_menu.id}")
        if !@dep_menu_pers.empty?
          flag=false
          @dep_menu_pers.each do |menu_per|
            if menu_per.priority_id==1
              flag=true
            end
          end
          if flag
            hos_ids.push(hos_menu.hos_id)
          end
        else
          if hos_menu.priority_id == 1
            hos_ids.push(hos_menu.hos_id)
          end
        end
      end
    end
    @hospitals=Hospital.where(id:hos_ids)
    @menu_id = params[:menu_id]
    @patient = Patient.new
    # @hospital = Hospital.where(id:params[:hos_id])
    # @department = Department.where(hospital_id:params[:hos_id])
    @dep = @patients_all.inspect
    oper_action_admin2s_path
    render partial: 'patients/form'
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
    default_access_url_prefix = Settings.aliyunOSS.photo_url#"http://mimas-open.oss-cn-hangzhou.aliyuncs.com/"
    if photo.nil?||photo==''
      photo='/default.png'
    else
      photo= default_access_url_prefix + photo
    end
    @my_photo = photo
    render partial: 'patients/patient_form'
  end

  def edit2    #含增删改查权限的 ############　删　################
    @menu_id = params[:menu_id]
    @patient = Patient.where(id:params[:id]).first
    @hospitals = Hospital.where(id:@patient.hospital_id)
    if !@patient.department_id.nil? && @patient.department_id != ''
      @departments = Department.where(id:@patient.department_id)
    else
      @departments = Department.where(hospital_id:@patient.hospital_id)
    end
    render partial: 'patients/form'
  end

  # POST /patients
  # POST /patients.json
  def create
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
        if !pat.photo.nil? && pat.photo != ''
          deleteFromAliyun('avatar/'+pat.photo,Settings.aliyunOSS.video_service,Settings.aliyunOSS.image_bucket)
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

  def is_executable      #针对每一行验证权限   #含增删改查权限的 ############　删　################
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

  def search_department2   #含增删改查权限的 ############　删　################
    @menu_id = params[:menu_id]
    @menu = Menu.where(name:'患者管理').first
    @child_menus = @menu.child_menus
    menu_ids = []
    if !@child_menus.empty?
      @child_menus.each do |child_menu|
        menu_ids.push(child_menu.id)
      end
    end
    @departments=Department.find_by_sql("select d.id,d.name from departments d,role2s r, menu_permissions mp , admin2s_role2s ar,role2s_menu_permissions rmp, menus where  mp.id=rmp.menu_permission_id and ar.admin2_id=#{current_user.id} and ar.role2_id=r.id and r.id=rmp.role2_id and menus.id=mp.menu_id and menus.parent_id in (#{menu_ids.to_s[1..-2]}) and mp.menu_id=menus.id and d.id=mp.department_id and d.hospital_id=#{params[:hos_id]} GROUP BY d.id;")
    # @departments=Department.find_by_sql("select d.id,d.name from departments d,role2s r, menu_permissions mp , admin2s_role2s ar,role2s_menu_permissions rmp, menus where  mp.id=rmp.menu_permission_id and ar.admin2_id=#{current_user.id} and ar.role2_id=r.id and r.id=rmp.role2_id and menus.id=mp.menu_id and menus.parent_id=#{@menu.parent_id} and mp.menu_id=menus.id and d.id=mp.department_id GROUP BY d.id;")
    if @departments.empty?
      @departments = Department.where(hospital_id:params[:hos_id])
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
    service = Settings.aliyunOSS.video_service
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
