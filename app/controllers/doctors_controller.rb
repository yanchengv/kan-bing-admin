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
      @hospitals = Hospital.all
    end
    render partial: 'doctors/doctor_manage'
  end
  def index2
    menu_name='医生管理'
    @hospitals=Doctor.new.manage_doctors(menu_name, current_user.id)
    @hos = Hospital.find_by(id:params[:hos_id])
    @hos_id = params[:hos_id]
    @dep_id = params[:dep_id]
    @menu_id = params[:menu_id]
    @menu = Menu.where(id:@menu_id).first
    # @departments=Department.find_by_sql("select d.id,d.name from departments d,role2s r, menu_permissions mp , admin2s_role2s ar,role2s_menu_permissions rmp, menus where  mp.id=rmp.menu_permission_id and ar.admin2_id=#{current_user.id} and ar.role2_id=r.id and r.id=rmp.role2_id and menus.id=mp.menu_id and menus.parent_id=#{@menu.parent_id} and mp.menu_id=menus.id and d.id=mp.department_id GROUP BY d.id;")
    @departments=Department.find_by_sql("select d.id,d.name from departments d,role2s r, menu_permissions mp , admin2s_role2s ar,role2s_menu_permissions rmp, menus where  mp.id=rmp.menu_permission_id and ar.admin2_id=#{current_user.id} and ar.role2_id=r.id and r.id=rmp.role2_id and menus.id=mp.menu_id and menus.parent_id=#{@menu_id} and mp.menu_id=menus.id and d.id=mp.department_id GROUP BY d.id;")
    if @departments.empty?
      @departments = Department.where(hospital_id:params[:hos_id])
    end
    # @dep = Department.find_by(id:params[:dep_id])
=begin
    hospital_ids = []
    department_ids = []
    @menu_permissions = MenuPermission.joins(role2s_menu_permissions:[{role2: [{admin2s_role2s: :admin2}]}]).where(admin2s:{id:current_user.id})
    if !@menu_permissions.empty?
      @menus=[]
      @menu_permissions.each do |menu_permission|
        @menus.push(menu_permission.menu)
      end
      @department_menus = []
      @menu_permissions.each do |menu_permission|
        flag=false
        @menu = Menu.where(name:'医院管理').first
        if menu_permission.menu.parent_id == @menu.id
          @child_menus = menu_permission.menu.all_child(@menus)
          if @child_menus != []
            @child_menus.each do |menu|
              if menu.name == '医生管理'
                flag=true
              elsif menu.name == '患者管理'
              else
                @department_menus.push(menu)
              end
            end
          end
          if flag
            if !menu_permission.hospital_id.nil? && menu_permission.hospital_id != ''
              hospital_ids.push(menu_permission.hospital_id)
            end
          end
        end
      end
      dep_menu_permissions = []
      if @department_menus != []
        @department_menus.each do |d_menu|
          dep_menu_permissions.push(d_menu.menu_permissions.first)
        end
      end
      if dep_menu_permissions != []
        dep_menu_permissions.each do |d_menu_per1|
          @menu_permissions.each do |menu_per1|
            if d_menu_per1.id == menu_per1.id
              if !d_menu_per1.department_id.nil? && d_menu_per1.department_id != ''
                department_ids.push(d_menu_per1.department_id)
              end
            end
          end
        end
      end
      #@hospitals = Hospital.where(id:hospital_ids)
       menu_name='医院人员'
       @hospitals=Doctor.new.manage_doctors menu_name
      # if hospital_ids == []
      #
      #   @hospitals = Hospital.all
      #   if !@hospitals.empty?
      #     @hospitals.each do |hos|
      #       hospital_ids.push(hos.id)
      #     end
      #   end
      # end
    end
    # @hos = Hospital.find_by(id:hospital_ids[0])
    # if !@hospitals.first.nil?
    #   @hos = Hospital.find_by(id:@hospitals.first.id)
    # end
    # dep_ids = []
    # @deps = nil
    # if department_ids != []
    #   @deps = Department.where(id:department_ids,hospital_id:hos_id)
    # else
    #   @deps = Department.where(hospital_id:hos_id)
    # end
=end
    render partial: 'doctors/doctor_manage'
  end  #含增删改查权限的 ############　删　################

  def show_index
    hos_id = current_user.hospital_id
    dep_id = current_user.department_id
    if !params[:hos_id].nil? && params[:hos_id] != ''
      hos_id = params[:hos_id]
    end
    if !params[:dep_id].nil? && params[:dep_id] != '' && params[:dep_id] != 'all'
      dep_id = params[:dep_id]
    end
    is_activated = params[:is_activated]
    noOfRows = params[:rows]
    page = params[:page]
    @doctors_all = nil
    if !hos_id.nil? && hos_id != '' && !dep_id.nil? && dep_id != ''
      @doctors_all = Doctor.where(hospital_id:hos_id,department_id:dep_id)
    elsif !hos_id.nil? && hos_id != ''
      @doctors_all = Doctor.where(hospital_id:hos_id)
    else
      @doctors_all = Doctor.all
    end
    field = params[:searchField]
    p params[:searchOper]
    value = params[:searchString]
    if !field.nil? && field!='' && !value.nil?
      @doctors_all =  @doctors_all.where("#{field} like ?", "%#{value}%")
    end
    if is_activated=='0'
      @doctors_all =  @doctors_all.where(is_activated:0)
    end
    if is_activated=='1'
      @doctors_all =  @doctors_all.where.not(is_activated:0)
    end
    records=0
    @total=0
    if !@doctors_all.nil? && !@doctors_all.empty?
      # "searchField"=>"name", "searchString"=>"张", "searchOper"=>"bw", "filters"=>""
      records = @doctors_all.length
      @doctors = @doctors_all.paginate(:per_page => noOfRows, :page => page)
      if !noOfRows.nil?
        if records%noOfRows.to_i == 0
          @total = records/noOfRows.to_i
        else
          @total = (records/noOfRows.to_i)+1
        end
      end
      @rows=[]
      @doctors.each do |doc|
        @province=Province.where(id:doc.province_id).first
        @city=City.where(id:doc.city_id).first
        @hospital=Hospital.where(id:doc.hospital_id).first
        @department=Department.where(id:doc.department_id).first


        @province.nil? ? province_name='':province_name=@province.name
        @city.nil? ? city_name='':city_name=@city.name
        @hospital.nil? ? hospital_name='':hospital_name=@hospital.name
        @department.nil? ? department_name='':department_name=@department.name
        a={id:doc.id,
           cell:[
               doc.id,
               doc.spell_code,
               doc.name,
               doc.credential_type,
               doc.credential_type_number,
               doc.gender,
               doc.birthday,
               doc.birthplace,
               # doc.province_id,
               province_name,
               city_name,
               hospital_name,
               department_name,
               # doc.city_id,
               # doc.hospital_id,
               # doc.department_id,
               doc.mobile_phone,
               doc.email,
               doc.professional_title,
               doc.introduction
           ]
        }
        @rows.push(a)
      end
    end
    @objJSON = {total:@total,rows:@rows,page:page,records:records}

    render :json => @objJSON.as_json
  end

  def show_index2  #含增删改查权限的 ############　删　################
      # @doctor = Doctor.new
      # @doctors = Doctor.all
     # Admin2.joins(admin2s_role2s:  [{ role2: [{role2s_menu_permissions: [{menu_permission: :priority},{menu_permission: :menu}]}] }]).where(id:current_user.id)
    # p Role2sMenuPermission.joins(:menu_permission).where(menu_permissions:{hospital_id:1})
    # p MenuPermission.joins(:priority,:menu).where(menu:{name:'医生管理'})
=begin
    hospital_ids = []
    department_ids = []
    @menu_permissions = MenuPermission.joins(role2s_menu_permissions:[{role2: [{admin2s_role2s: :admin2}]}]).where(admin2s:{id:current_user.id})
    if !@menu_permissions.empty?
      @menus=[]
      @menu_permissions.each do |menu_permission|
        @menus.push(menu_permission.menu)
      end
      @department_menus = []
      @menu_permissions.each do |menu_permission|
        flag=false
        @menu = Menu.where(name:'医院管理').first
        if menu_permission.menu.parent_id == @menu.id
          @child_menus = menu_permission.menu.all_child(@menus)
          if @child_menus != []
            @child_menus.each do |menu|
              if menu.name == '医生管理'
                flag=true
              elsif menu.name == '患者管理'
              else
                @department_menus.push(menu)
              end
            end
          end
          if flag
            if !menu_permission.hospital_id.nil? && menu_permission.hospital_id != ''
              hospital_ids.push(menu_permission.hospital_id)
            end
          end
        end
      end
      dep_menu_permissions = []
      if @department_menus != []
        @department_menus.each do |d_menu|
          dep_menu_permissions.push(d_menu.menu_permissions.first)
        end
      end
      if dep_menu_permissions != []
        dep_menu_permissions.each do |d_menu_per1|
          @menu_permissions.each do |menu_per1|
            if d_menu_per1.id == menu_per1.id
              if !d_menu_per1.department_id.nil? && d_menu_per1.department_id != ''
                department_ids.push(d_menu_per1.department_id)
              end
            end
          end
        end
      end
      #@hospitals = Hospital.where(id:hospital_ids)
      menu_name='医院人员'
      @hospitals=Doctor.new.manage_doctors menu_name
      # if hospital_ids == []
      #
      #   @hospitals = Hospital.all
      #   if !@hospitals.empty?
      #     @hospitals.each do |hos|
      #       hospital_ids.push(hos.id)
      #     end
      #   end
      # end
    end
    if !@hospitals.empty?
      @hospitals.each do |hos|
        @menu_per = MenuPermission.where(hospital_id:hos.id)
        @menu = @menu_per.menu
      end
    end
    if !@hospitals.first.nil?
      hos_id = @hospitals.first.id
    end
    if !params[:hos_id].nil?
      hos_id = params[:hos_id]
    end
    # dep_ids = []
    # @deps = nil
    # if department_ids != []
    #   @deps = Department.where(id:department_ids,hospital_id:hos_id)
    # else
    #   @deps = Department.where(hospital_id:hos_id)
    # end
    # # @deps = Department.where(id:department_ids)
    # if !@deps.empty?
    #   @deps.each do |dep|
    #     if dep.hospital_id.to_i==hos_id.to_i
    #       dep_ids.push(dep.id)
    #     end
    #   end
    # end
    # dep_id = dep_ids
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
    @departments=Department.find_by_sql("select d.id from departments d,role2s r, menu_permissions mp , admin2s_role2s ar,role2s_menu_permissions rmp, menus where  mp.id=rmp.menu_permission_id and ar.admin2_id=#{current_user.id} and ar.role2_id=r.id and r.id=rmp.role2_id and menus.id=mp.menu_id and menus.parent_id in (#{menu_ids.to_s[1..-2]})and mp.menu_id=menus.id and d.id=mp.department_id and d.hospital_id=#{params[:hos_id]} GROUP BY d.id;")
    p @departments
    if @departments.empty? || @departments == []
      dep_id = ''
    end
    priority_ids = params[:priority_ids]
    if !priority_ids.nil?
      # @menu = Menu.find_by(id:params[:menu_id])
      # @menu = Menu.find_by_sql("select m.id,m.name from menu_permissions mp,menus m, role2s_menu_permissions rmp, admin2s_role2s ar where mp.menu_id=m.id and rmp.menu_permission_id=mp.id and rmp.role2_id=ar.role2_id and ar.admin2_id=#{current_user.id} and m.parent_id=#{@menu.parent_id} and mp.hospital_id=#{params[:hos_id]}").first
      @departments=Department.find_by_sql("select d.id from departments d,role2s r, menu_permissions mp , admin2s_role2s ar,role2s_menu_permissions rmp, menus where  mp.id=rmp.menu_permission_id and ar.admin2_id=#{current_user.id} and ar.role2_id=r.id and r.id=rmp.role2_id and menus.id=mp.menu_id and menus.parent_id in (#{menu_ids.to_s[1..-2]}) and mp.menu_id=menus.id and d.id=mp.department_id and d.hospital_id=#{params[:hos_id]} GROUP BY d.id;")
      priority_ids = priority_ids.split(',')
      p priority_ids
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
      p @last_dep
      if !@last_dep.nil?
        dep_id = @last_dep
      end
    end
    p 'aa'
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
      is_activated = params[:is_activated]
      noOfRows = params[:rows]
      page = params[:page]
      @menu_name = params[:menu_name]
      @doctors_all = nil
      if !hos_id.nil? && hos_id != '' && !dep_id.nil? && dep_id != ''
        @doctors_all = Doctor.where(hospital_id:hos_id,department_id:dep_id)
      elsif !hos_id.nil? && hos_id != ''
        @doctors_all = Doctor.where(hospital_id:hos_id)
      # else
      #   @doctors_all = Doctor.all
      end
    field = params[:searchField]
    p params[:searchOper]
    value = params[:searchString]
    if !field.nil? && field!='' && !value.nil?
      @doctors_all =  @doctors_all.where("#{field} like ?", "%#{value}%")
    end
      if is_activated=='0'
        @doctors_all =  @doctors_all.where(is_activated:0)
      end
      if is_activated=='1'
        @doctors_all =  @doctors_all.where.not(is_activated:0)
      end
      records=0
      @total=0
      if !@doctors_all.nil? && !@doctors_all.empty?
        # "searchField"=>"name", "searchString"=>"张", "searchOper"=>"bw", "filters"=>""
        records = @doctors_all.length
        @doctors = @doctors_all.paginate(:per_page => noOfRows, :page => page)
        if !noOfRows.nil?
          if records%noOfRows.to_i == 0
            @total = records/noOfRows.to_i
          else
            @total = (records/noOfRows.to_i)+1
          end
        end
        @rows=[]
        @doctors.each do |doc|
          @province=Province.where(id:doc.province_id).first
          @city=City.where(id:doc.city_id).first
          @hospital=Hospital.where(id:doc.hospital_id).first
          @department=Department.where(id:doc.department_id).first


          @province.nil? ? province_name='':province_name=@province.name
          @city.nil? ? city_name='':city_name=@city.name
          @hospital.nil? ? hospital_name='':hospital_name=@hospital.name
          @department.nil? ? department_name='':department_name=@department.name
          a={id:doc.id,
             cell:[
                 doc.id,
                 doc.name,
                 doc.credential_type,
                 doc.credential_type_number,
                 doc.gender,
                 doc.birthday,
                 doc.birthplace,
                 # doc.province_id,
                 province_name,
                 city_name,
                 hospital_name,
                 department_name,
                 # doc.city_id,
                 # doc.hospital_id,
                 # doc.department_id,
                 doc.mobile_phone,
                 doc.email,
                 doc.professional_title,
                 doc.introduction
             ]
          }
          @rows.push(a)
        end
      end
      @objJSON = {total:@total,rows:@rows,page:page,records:records}

      render :json => @objJSON.as_json
    #   p @objJSON.as_json

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
      @hospitals = Hospital.where(id:hos_id)
      if !dep_id.nil? && dep_id != ''
        @departments = Department.where(id:dep_id)
      else
        @departments = Department.where(hosptial_id:hos_id)
      end
    else
      @hospitals = Hospital.all
    end
    @doctor = Doctor.new
    render partial: 'doctors/form'
  end

  def new2   #含增删改查权限的 ############　删　################
=begin
    @menu_id = params[:menu_id]
    @doctor = Doctor.new
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
    if menu_permission_hos_id != []
      @hospital = Hospital.where(id:menu_permission_hos_id)
    else
      @hospital = Hospital.all
    end
    if menu_permission_dep_id != []
      @department = Department.where(id:menu_permission_dep_id)
    else
      @department = Department.all
    end
=end
    menu_name = '医生管理'
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
    # @hospitals=Hospital.find_by_sql("select h.id,h.name from hospitals h,role2s r, menu_permissions mp , admin2s_role2s ar,role2s_menu_permissions rmp, menus where  mp.id=rmp.menu_permission_id and ar.admin2_id=#{current_user.id} and ar.role2_id=r.id and r.id=rmp.role2_id and menus.id=mp.menu_id and menus.parent_id=#{@menu.id} and mp.menu_id=menus.id and h.id=mp.hospital_id and mp.priority_id=1 GROUP BY h.id;")
    @menu_id = params[:menu_id]
    # @menu = Menu.where(id:@menu_id).first
    # @departments=Department.find_by_sql("select d.id,d.name from departments d,role2s r, menu_permissions mp , admin2s_role2s ar,role2s_menu_permissions rmp, menus where  mp.id=rmp.menu_permission_id and ar.admin2_id=#{current_user.id} and ar.role2_id=r.id and r.id=rmp.role2_id and menus.id=mp.menu_id and menus.parent_id=#{@menu_id} and mp.menu_id=menus.id and d.id=mp.department_id and d.hospital_id=#{params[:hos_id]} GROUP BY d.id;")
    @doctor = Doctor.new
    # @hospitals = Hospital.where(id:params[:hos_id])
    # @department = Department.where(hospital_id:params[:hos_id])
    render partial: 'doctors/form'
  end

  # GET /doctors/1/edit
  def edit
    hos_id = current_user.hospital_id
    dep_id = current_user.department_id
    if !hos_id.nil? && hos_id != ''
      @hospitals = Hospital.where(id:hos_id)
      if !dep_id.nil? && dep_id != ''
        @departments = Department.where(id:dep_id)
      else
        @departments = Department.where(hosptial_id:hos_id)
      end
    else
      @hospitals = Hospital.all
    end
    @doctor = Doctor.where(id:params[:id]).first
    render partial: 'doctors/form'
  end

  def edit2   #含增删改查权限的 ############　删　################
=begin
    @menu_id = params[:menu_id]
    @doctor = Doctor.where(id:params[:id]).first
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
    if menu_permission_hos_id != []
      @hospital = Hospital.where(id:menu_permission_hos_id)
    else
      @hospital = Hospital.all
    end
    if menu_permission_dep_id != []
      @department = Department.where(id:menu_permission_dep_id)
    else
      @department = Department.all
    end
=end
    menu_name = '医生管理'
    @menu=Menu.where(name:menu_name).first
    @hos_menus = Menu.find_by_sql("select m.id,m.name,mp.hospital_id as hos_id,mp.priority_id from menu_permissions mp,menus m, role2s_menu_permissions rmp, admin2s_role2s ar where mp.menu_id=m.id and rmp.menu_permission_id=mp.id and rmp.role2_id=ar.role2_id and ar.admin2_id=#{current_user.id} and m.parent_id=#{@menu.id}")
    hos_ids = []
    if !@hos_menus.empty?
      @hos_menus.each do |hos_menu|
        @dep_menu_pers = MenuPermission.find_by_sql("select mp.menu_id,mp.hospital_id,mp.priority_id from menu_permissions mp,menus m, role2s_menu_permissions rmp, admin2s_role2s ar where mp.menu_id=m.id and rmp.menu_permission_id=mp.id and rmp.role2_id=ar.role2_id and ar.admin2_id=#{current_user.id} and m.parent_id=#{hos_menu.id}")
        if !@dep_menu_pers.empty?
          flag=false
          @dep_menu_pers.each do |menu_per|
            if menu_per.priority_id==3
              flag=true
            end
          end
          if flag
            hos_ids.push(hos_menu.hos_id)
          end
        else
          if hos_menu.priority_id == 3
            hos_ids.push(hos_menu.hos_id)
          end
        end
      end
    end
    @hospitals=Hospital.where(id:hos_ids)
    # @hospitals=Hospital.find_by_sql("select h.id,h.name from hospitals h,role2s r, menu_permissions mp , admin2s_role2s ar,role2s_menu_permissions rmp, menus where  mp.id=rmp.menu_permission_id and ar.admin2_id=#{current_user.id} and ar.role2_id=r.id and r.id=rmp.role2_id and menus.id=mp.menu_id and menus.parent_id=#{@menu.id} and mp.menu_id=menus.id and h.id=mp.hospital_id and mp.priority_id=1 GROUP BY h.id;")
    @menu_id = params[:menu_id]
    @doctor = Doctor.where(id:params[:id]).first
    @menu1 = Menu.where(name:'医生管理').first
    @child_menus = @menu1.child_menus
    menu_ids = []
    if !@child_menus.empty?
      @child_menus.each do |child_menu|
        menu_ids.push(child_menu.id)
      end
    end
    @departments=Department.find_by_sql("select d.id,d.name from departments d,role2s r, menu_permissions mp , admin2s_role2s ar,role2s_menu_permissions rmp, menus where  mp.id=rmp.menu_permission_id and ar.admin2_id=#{current_user.id} and ar.role2_id=r.id and r.id=rmp.role2_id and menus.id=mp.menu_id and menus.parent_id in (#{menu_ids.to_s[1..-2]}) and mp.menu_id=menus.id and d.id=mp.department_id and d.hospital_id=#{@doctor.hospital_id} and mp.priority_id=1 GROUP BY d.id;")
    if @departments.empty?
      @departments = Department.where(hospital_id:@doctor.hospital_id)
    end
    @hospitals = Hospital.where(id:@doctor.hospital_id)
    if !@doctor.department_id.nil? && @doctor.department_id != ''
      @departments = Department.where(id:@doctor.department_id)
    else
      @departments = Department.where(hospital_id:@doctor.hospital_id)
    end
    # @hospital = Hospital.where(id:params[:hos_id])
    # @department = Department.where(hospital_id:params[:hos_id])
    render partial: 'doctors/form'
  end

  # POST /doctors
  # POST /doctors.json
  def create
    @doctor = Doctor.new(doctor_params)
    if @doctor.save
      render json:{success:'true',data:@doctor}
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
    render json:{success:true}
    # @doctor.destroy
    # respond_to do |format|
    #   format.html { redirect_to doctors_url, notice: 'Doctor was successfully destroyed.' }
    #   format.json { head :no_content }
    # end
  end

  def get_department
    @departments = Department.where(hospital_id:params[:hospital_id])
    if !current_user.department_id.nil? && current_user.department_id != ''
      @departments = Department.where(id:current_user.department_id)
    end
    if params[:model_class] == 'patient'
      render partial: 'patients/department_partial'
    else
      render partial: 'doctors/department_partial'
    end
  end

  def get_department2   #含增删改查权限的 ############　删　################
=begin
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
    if !@hospital_id.nil? || @hospital_id !=''
      @department = Department.where(hospital_id:@hospital_id)
    end
    # @doctor = Doctor.new
    # @doctor.set_part
    # render json:{success:true,data:@department}
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
    @departments=Department.find_by_sql("select d.id,d.name from departments d,role2s r, menu_permissions mp , admin2s_role2s ar,role2s_menu_permissions rmp, menus where  mp.id=rmp.menu_permission_id and ar.admin2_id=#{current_user.id} and ar.role2_id=r.id and r.id=rmp.role2_id and menus.id=mp.menu_id and menus.parent_id in (#{menu_ids.to_s[1..-2]}) and mp.menu_id=menus.id and d.id=mp.department_id and d.hospital_id=#{params[:hospital_id]} and mp.priority_id=1 GROUP BY d.id;")
    p  @departments
    if @departments.empty? || @departments == []
      @departments = Department.where(hospital_id:params[:hospital_id])
    end
    if params[:model_class] == 'patient'
      render partial: 'patients/department_partial'
    else
      render partial: 'doctors/department_partial'
    end
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
    elsif params[:model_class] == 'patient'
      render partial: 'patients/hospital_partial'
    else
      render partial: 'doctors/hospital_partial'
    end
  end

  def is_executable   #针对每一行验证权限   #含增删改查权限的 ############　删　################
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
      is_activated=true
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
        if @doctor.is_activated == 1
          is_activated=false
        end
      end
      if !@menu_permissions.empty? && !@doctors.nil? && !@doctors.empty?
        p 'doctors'
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
            if doctor.is_activated == 1
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
            if is_delete == false
              is_delete=is_d
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
    if !current_user.department_id.nil? && current_user.department_id != ''
      @departments = Department.where(id:current_user.department_id)
    end
    render partial: 'doctors/search_department'
  end

  def search_department2    #含增删改查权限的 ############　删　################
    @menu_id = params[:menu_id]
    @menu = Menu.find_by(id:@menu_id).parent_menu
    @child_menus = @menu.child_menus
    menu_ids = []
    if !@child_menus.empty?
      @child_menus.each do |child_menu|
        menu_ids.push(child_menu.id)
      end
    end
    @departments=Department.find_by_sql("select d.id,d.name from departments d,role2s r, menu_permissions mp , admin2s_role2s ar,role2s_menu_permissions rmp, menus where  mp.id=rmp.menu_permission_id and ar.admin2_id=#{current_user.id} and ar.role2_id=r.id and r.id=rmp.role2_id and menus.id=mp.menu_id and menus.parent_id in (#{menu_ids.to_s[1..-2]}) and mp.menu_id=menus.id and d.id=mp.department_id and d.hospital_id=#{params[:hos_id]} GROUP BY d.id;")
    # @departments=Department.find_by_sql("select d.id,d.name from departments d,role2s r, menu_permissions mp , admin2s_role2s ar,role2s_menu_permissions rmp, menus where  mp.id=rmp.menu_permission_id and ar.admin2_id=#{current_user.id} and ar.role2_id=r.id and r.id=rmp.role2_id and menus.id=mp.menu_id and menus.parent_id=#{@menu.parent_id} and mp.menu_id=menus.id and d.id=mp.department_id GROUP BY d.id;")
    if @departments.empty? || @departments == []
      @departments = Department.where(hospital_id:params[:hos_id])
    end
=begin
    @menu_permissions = MenuPermission.joins(role2s_menu_permissions:[{role2: [{admin2s_role2s: :admin2}]}]).where(admin2s:{id:current_user.id})
    if !@menu_permissions.empty?
      # hospital_ids = []
      department_ids = []
      @department_menus = []
      @menus=[]
      @menu_permissions.each do |menu_permission|
        @menus.push(menu_permission.menu)
      end
      @menu_permissions.each do |menu_permission|
        @menu = Menu.where(name:'医院管理').first
        if menu_permission.menu.parent_id == @menu.id
          # hospital_ids.push(menu_permission.hospital_id)
          @child_menus = menu_permission.menu.all_child(@menus)
          if @child_menus != []
            @child_menus.each do |menu|
              if menu.name == '医生管理'
              elsif menu.name == '患者管理'
              else
                @department_menus.push(menu)
              end
            end
          end
          if !menu_permission.department_id.nil? && menu_permission.department_id != ''
            department_ids.push(menu_permission.department_id)
          end
        end
      end
      dep_menu_permissions = []
      if @department_menus != []
        @department_menus.each do |d_menu|
          dep_menu_permissions.push(d_menu.menu_permissions.first)
        end
      end
      if dep_menu_permissions != []
        dep_menu_permissions.each do |d_menu_per1|
          @menu_permissions.each do |menu_per1|
            if d_menu_per1.id == menu_per1.id
              if !d_menu_per1.department_id.nil? && d_menu_per1.department_id != ''
                department_ids.push(d_menu_per1.department_id)
              end
            end
          end
        end
      end
      if department_ids == []
        @departments = Department.where(hospital_id:params[:hos_id])
      else
        @departments = Department.where(id:department_ids,hospital_id:params[:hos_id])
      end
    end
=end
    render partial: 'doctors/search_department'
  end

  def is_permission    #验证权限的方法(医生患者通用)　#含增删改查权限的 ############　删　################
    add_flag=false
    delete_flag=false
    update_flag=false
    show_flag=false
    all_flag=true
    hos_id = params[:hospital_id]
    dep_id = params[:department_id]
    @menu_id = params[:menu_id]
    @menu = Menu.find_by(id:@menu_id).parent_menu
    @child_menus = @menu.all_child(Menu.all)
    if @child_menus != []
      @child_menus.each do |child_menu|
        @hos_menu = Menu.find_by_sql("select m.id,m.name from menu_permissions mp,menus m, role2s_menu_permissions rmp, admin2s_role2s ar where mp.menu_id=m.id and rmp.menu_permission_id=mp.id and rmp.role2_id=ar.role2_id and ar.admin2_id=#{current_user.id} and m.parent_id=#{@menu.id} and mp.hospital_id=#{params[:hospital_id]}").first
        @dep_menu = Menu.find_by_sql("select m.id,m.name from menu_permissions mp,menus m, role2s_menu_permissions rmp, admin2s_role2s ar where mp.menu_id=m.id and rmp.menu_permission_id=mp.id and rmp.role2_id=ar.role2_id and ar.admin2_id=#{current_user.id} and m.parent_id=#{@hos_menu.id}")
        if dep_id=='' || dep_id== 'all'
          p @hos_menu
          # if @dep_menu != []
            add_flag = true
            delete_flag = false
            update_flag = false
            show_flag = true
          # else
          #   @menu_permissions = MenuPermission.find_by_sql("select mp.priority_id from menu_permissions mp,menus m, role2s_menu_permissions rmp, admin2s_role2s ar where mp.menu_id=m.id and rmp.menu_permission_id=mp.id and rmp.role2_id=ar.role2_id and ar.admin2_id=#{current_user.id} and m.id=#{child_menu.id} and mp.hospital_id=#{hos_id}")
          # end
        else
          if @dep_menu != []
            @menu_permissions = MenuPermission.find_by_sql("select mp.priority_id from menu_permissions mp,menus m, role2s_menu_permissions rmp, admin2s_role2s ar where mp.menu_id=m.id and rmp.menu_permission_id=mp.id and rmp.role2_id=ar.role2_id and ar.admin2_id=#{current_user.id} and m.id=#{child_menu.id} and mp.hospital_id=#{hos_id} and mp.department_id=#{dep_id}")
          else
            @menu_permissions = MenuPermission.find_by_sql("select mp.priority_id from menu_permissions mp,menus m, role2s_menu_permissions rmp, admin2s_role2s ar where mp.menu_id=m.id and rmp.menu_permission_id=mp.id and rmp.role2_id=ar.role2_id and ar.admin2_id=#{current_user.id} and m.id=#{child_menu.id} and mp.hospital_id=#{hos_id}")
          end
        end
        if @menu_permissions != []
          break
        end
      end
    end
    p @menu_permissions
    if !@menu_permissions.nil? && !@menu_permissions.empty?
      @menu_permissions.each do |menu_permission|
        if menu_permission['priority_id'] == 1
          add_flag = true
        end
        if menu_permission['priority_id'] == 2
          delete_flag = true
        end
        if menu_permission['priority_id'] == 3
          update_flag = true
        end
        if menu_permission['priority_id'] == 4
          show_flag = true
        end
      end
    end
=begin
    @menu_permissions = MenuPermission.joins(role2s_menu_permissions:[{role2: [{admin2s_role2s: :admin2}]}]).where(admin2s:{id:current_user.id})
    if !@menu_permissions.empty?
      @menu_permissions.each do |menu_permission|
        @menu = Menu.where(name:'人员管理').first
        @menu1 = menu_permission.menu
        if !@menu.nil? && @menu1.name=='医生管理' && @menu1.parent_id == @menu.id
          if menu_permission.priority_id == 1
            add_flag = true
          end
          if menu_permission.priority_id == 2
            delete_flag = true
          end
          if menu_permission.priority_id == 3
            update_flag = true
          end
          if menu_permission.priority_id == 4
            show_flag = true
          end
          all_flag = false
        end
      end
      p all_flag
      if all_flag
      @menus=[]
      @menu_permissions.each do |menu_permission|
        @menus.push(menu_permission.menu)
      end
      @dep_menu_pers = []
      @menu_permissions.each do |menu_permission|
        @menu = Menu.where(name:'医院管理').first
        if menu_permission.menu.parent_id == @menu.id
          if menu_permission.hospital_id == hos_id
            @all_child_menus = menu_permission.menu.all_child(@menus)
            if @child_menus != []
              @all_child_menus.each do |menu|
                if menu.name == '医生管理'
                  menu.menu_permissions.each do |menu_per|
                    @menu_permissions.each do |menu_permission2|
                      if menu_per.id == menu_permission2.id
                        if menu_per.priority_id == 1
                          add_flag = true
                        end
                        if menu_per.priority_id == 2
                          delete_flag = true
                        end
                        if menu_per.priority_id == 3
                          update_flag = true
                        end
                        if menu_per.priority_id == 4
                          show_flag = true
                        end
                      end
                    end
                  end
                end
              end
            end
            @child_menus = menu_permission.menu.child_menus
            if !@child_menus.empty?
              @child_menus.each do |menu|
                if menu.name == '医生管理'
                  menu.menu_permissions.each do |menu_per|
                    @menu_permissions.each do |menu_permission2|
                      if menu_per.id == menu_permission2.id
                        if menu_per.priority_id == 1
                          add_flag = true
                        end
                        if menu_per.priority_id == 2
                          delete_flag = true
                        end
                        if menu_per.priority_id == 3
                          update_flag = true
                        end
                        if menu_per.priority_id == 4
                          show_flag = true
                        end
                      end
                    end
                  end
                elsif menu.name == '患者管理'
                else
                  @dep_menu_pers.push(menu.menu_permissions.first)
                end
              end
            end
          end
        end
      end
      if @dep_menu_pers != []
        @dep_menu_pers.each do |dep_men_per|
          if dep_men_per.department_id == dep_id
            add_flag = false
            delete_flag = false
            update_flag = false
            show_flag = false
            @child_menus = dep_men_per.menu.child_menus
            if !@child_menus.empty?
              @child_menus.each do |menu|
                if menu.name == '医生管理'
                  menu.menu_permissions.each do |menu_per|
                    @menu_permissions.each do |menu_permission2|
                      if menu_per.id == menu_permission2.id
                        if menu_per.priority_id == 1
                          add_flag = true
                        end
                        if menu_per.priority_id == 2
                          delete_flag = true
                        end
                        if menu_per.priority_id == 3
                          update_flag = true
                        end
                        if menu_per.priority_id == 4
                          show_flag = true
                        end
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end
      end
    end
=end
    p add_flag,delete_flag,update_flag,show_flag
    render json: {add:add_flag,delete:delete_flag,update:update_flag,show:show_flag}
  end

  def get_doc_by_priority  #给定权限值,获得有该权限的Department  #含增删改查权限的 ############　删　################
    p params[:priority_ids]
    priority_ids = params[:priority_ids]
    @menu = Menu.find_by(id:params[:menu_id])
    priority_ids = priority_ids.split(',')
    if priority_ids != []
      priority_ids.each do |priority_id|
        if !@menu.child_menus.empty?
            @dep = Department.find_by_sql("select d.id,d.name from departments d,menus m, menu_permissions mp, role2s_menu_permissions rmp, admin2s_role2s ar where mp.menu_id=m.id and rmp.menu_permission_id=mp.id and mp.department_id=d.id and rmp.role2_id=ar.role2_id and ar.admin2_id=#{current_user.id} and m.parent_id=#{@menu.id} and mp.hospital_id=#{params[:hos_id]} and mp.priority_id=#{priority_id}")
            if !@last_dep.nil?
              @dep = (@last_dep&@dep)
            end
            @last_dep = @dep
        end
      end
    end
    p @last_dep
  end

  def check_email           #用于页面验证
    @doctor = Doctor.find_by(id:params[:doctor_id])
    email=params[:email]
    @user=Doctor.where('email=?',email)
    p @user
    if !@doctor.nil?
      if !@user.empty? && @doctor.email!=email
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
    end  end
  def check_phone      #用于页面验证
    @doctor = Doctor.find_by(id:params[:doctor_id])
    mobile_phone=params[:phone]
    @user=Doctor.where('mobile_phone=?',mobile_phone)
    p @user
    if !@doctor.nil?
      if !@user.empty? && @doctor.mobile_phone!=mobile_phone
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
  def check_credential_type_number     #用于页面验证
    @doctor = Doctor.find_by(id:params[:doctor_id])
    credential_type_number = params[:credential_type_number]
    @user=Doctor.where('credential_type_number=?',credential_type_number)
    if !@doctor.nil?
      if !@user.empty? && @doctor.credential_type_number!=credential_type_number
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

  def get_hospitals
    docs = {}
    # docs[0] = '----请选择----'
    if current_user.admin_type == '医院管理员'
      @hospital = Hospital.find_by(id:current_user.hospital_id)
      if !@hospital.nil?
        docs[@hospital.id] = @hospital.name
      end
    else
      @hospitals = Hospital.all
      @hospitals.each do |hos|
        docs[hos.id] = hos.name
      end
    end
    render :json => {:hospitals => docs.as_json}
  end

  def get_departments
    @departments = Department.all
    if !params[:hospital_id].nil?
      @departments = Department.where(hospital_id:params[:hospital_id])
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
                                     :wechat, :rewards, :is_checked, :is_activated, :verify_code,:is_public, :patient_id )
    end
end
