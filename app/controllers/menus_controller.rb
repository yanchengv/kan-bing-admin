class MenusController < ApplicationController
  require 'will_paginate/array'
  before_filter :signed_in_user
  before_action :set_menu, only: [ :edit, :update, :destroy]

  # GET /menus
  # GET /menus.json


  def index
    render partial: 'menus/menu_manage'
  end

  def show_index
    sql = 'true'
    # if params[:name] && params[:name] != ''
    #   sql << " and name like '%#{params[:name]}%'"
    # end
    # if params[:email] && params[:email] != ''
    #   sql << " and email like '%#{params[:email]}%'"
    # end
    # if params[:photo] && params[:photo] != ''
    #   sql << " and name like '%#{params[:photo]}%'"
    # end
    @all_menus = Menu.where(sql)
    count = @all_menus.count
    @menus=[]
    if count>0
      @all_menus.each do |menu|
        @per_names = []
        if !menu.menu_permissions.empty?
          menu.menu_permissions.each do |menu_permission|
            if !menu_permission.priority.nil?
              @per_names.push(menu_permission.priority.name)
            end
          end
        end
        p @per_names
        parent_name=''
        if menu.parent_menu
          parent_name = menu.parent_menu.name
        end
        @menu = {id:menu.id,name:menu.name,parent_name:parent_name,priorities:@per_names,uri:menu.uri}
        @menus.push(@menu)
      end
    end
    totalpages = count % params[:rows].to_i == 0 ? count / params[:rows].to_i : count / params[:rows].to_i + 1
    # @menus = @menus.limit(params[:rows].to_i).offset(params[:rows].to_i*(params[:page].to_i-1))
    @menus = @menus.paginate(:per_page => params[:rows], :page => params[:page])
    render :json => {:menus => @menus.as_json, :totalpages => totalpages, :currpage => params[:page].to_i, :totalrecords => count}
  end

  def oper_action
    if params[:oper] == 'add'
      create
    elsif params[:oper] == 'del'
      destroy
    elsif params[:oper] == 'edit'
      update
    end
  end

  def role_manage
    id=params[:id]
    id ? @admin_id=id : @admin_id=false
    menus=[]
    @admin2=Admin2.where(id:id).first
    if  @admin2
      admin_menus=Admin2Menu.select('menu_id').where(admin2_id: @admin2.id)
      if  !admin_menus.nil?
      admin_menus.each do |admin_menu|
        menus.push(admin_menu.menu_id)
      end
      @admin_menus=Menu.select('id','parent_id as pId','name','table_name','model_class').where(id:menus)
      end

    end
    @menus = Menu.select('id','parent_id as pId','name','table_name','model_class').all
    render partial:  'menus/role_manage'
  end

  def show_all_menus
    # @all_menus = Menu.select('id','parent_id as pId','name','table_name','model_class').all
    # @total_menus=[]
    # @total_menus = @all_menus.as_json
    # @all_menus.each do |menu|
    #   if menu.child_menus.empty?
    #     # if menu.menu_permissions.priority_ids.nil?
    #     #   menu.menu_permissions.priority_ids = '4'
    #     # end
    #     # @menu_permission = Priority.where(id:menu.menu_permission.priority_ids.split(','))
    #     # if !@menu_permission.empty?
    #     #   @menu_permission.each do |per|
    #     #     @per = {id:'priority_'+per.id.to_s,pId:menu.id,name:per.name}.as_json
    #     #     @total_menus.push(@per)
    #     #   end
    #     # end
    #   end
    # end
    admin_priority = current_user.admin_priority params[:menu_id]
    p admin_priority
    @add_flag=admin_priority[:add_flag]
    @delete_flag=admin_priority[:delete_flag]
    @update_flag=admin_priority[:update_flag]
    @show_flag=admin_priority[:show_flag]
    p @add_flag,@delete_flag,@update_flag,@show_flag
    @add_flag=true
    @delete_flag=true
    @update_flag=true
    @show_flag=true
    p @add_flag,@delete_flag,@update_flag,@show_flag
    menu_permissions = MenuPermission.all
    @role = Role2.new
    all_tree = @role.menu_ztree2(menu_permissions)
    @all_tree=[]
    if !all_tree.empty?
      all_tree.each do |tree|
        if !tree.nil?
          @all_tree.push(tree)
        end
      end
    end
    @total_menus = {name:'菜单及权限列表',children:@all_tree,open:true}
    p @total_menus
    @all_role= Role2.all
    @all_roles=[]
    @all_role.each do |role|
      p 'role'
      p role.name
      if role.get_zTree == []
        @role = {id:'role-'+role.id.to_s,name:role.name,pId:0,menu_permission_id:'',open:true}
      else
        @role = {id:'role-'+role.id.to_s,name:role.name,pId:0,menu_permission_id:'',children:role.get_zTree,open:true}
      end
      @all_roles.push(@role)
    end
    p 'a'
    @all_roles = {name:'角色列表',children:@all_roles,open:true}
    p @all_roles.as_json

    @admin2s = Admin2.all
    @role2s = Role2.all
    admin_roles = []
    if !@admin2s.empty?
      @admin2s.each do |admin|
        roles = []
        if !admin.role2s.empty?
          admin.role2s.each do |role|
            @role = {id:'role-'+role.id.to_s,name:role.name,pId:admin.id,children:role.get_zTree}
            roles.push(@role)
          end
        end
        @admin = {id:admin.id,name:admin.name,children:roles}
        admin_roles.push(@admin)
      end
    end
    @admin2s_role2 = {name:'系统管理员',children:admin_roles,open:true}

    render partial: 'menus/show_all_menus'
  end

  def drag
    p params[:data]
    puts 'baek'
    p params[:targetNode]
    p params[:nodes]
    p_role_id = params[:targetNode]['id']
    role_id = p_role_id[p_role_id.index('-')+1,p_role_id.length]
    all_nodes = params[:data]
    all_nodes.each do |node|
      params[:nodes].each do |a|
        p_id = a[1]['id']
        if (!p_id.index('_').nil?)
          p '>>>>'
          if node[1]['id'] == a[1]['pId']
          else
            node[1]['menu_permission_id'].each do |menu_permission_id|
              @select_role_menu_pers = Role2sMenuPermission.where(role2_id:role_id,menu_permission_id:menu_permission_id)
              if @select_role_menu_pers.empty?
                @role_menu_per = Role2sMenuPermission.create(role2_id:role_id,menu_permission_id:menu_permission_id)
              end
            end
          end
        else
          node[1]['menu_permission_id'].each do |menu_permission_id|
            @select_role_menu_pers = Role2sMenuPermission.where(role2_id:role_id,menu_permission_id:menu_permission_id)
            if @select_role_menu_pers.empty?
              @role_menu_per = Role2sMenuPermission.create(role2_id:role_id,menu_permission_id:menu_permission_id)
            end
          end
        end
      end
    end
    render :json => @all_roles.as_json
  end

  def drag2
    p params[:targetNode]
    p params[:nodes]
    @menu = Menu.where(id:params[:nodes]).first
    if !@menu.nil?
      @menu.update(parent_id:params[:targetNode])
    end
    render :json => {success:true}
  end

  def remove_nodes
    menu_id =  params[:data]['id']
    p_role_id = params[:targetNode]['id']
    role_id = p_role_id[p_role_id.index('-')+1,p_role_id.length]
    if  menu_id.include? 'role-'
      role2_id = menu_id[menu_id.index('-')+1,menu_id.length]
      @role = Role2.where(id:role2_id).first
      if !@role.nil?
        @role.destroy
      end
    else
      @role2 = Role2.where(id:role_id).first
      @menu = Menu.find_by(id:menu_id)
      @menu_permission_ids = []
      str = "_"
      if menu_id.include? str
        @menu_permission_ids = params[:data]["menu_permission_id"]
      else
        menu_per_ids = []
        if !@menu.nil?
          if !@menu.child_menus.empty?
            @menu.all_child(Menu.all).each do |menu|
              if !menu.menu_permissions.empty?
                menu.menu_permissions.each do |menu_per|
                  menu_per_ids.push(menu_per.id)
                end
              end
            end
          end
          if !@menu.menu_permissions.empty?
            @menu.menu_permissions.each do |menu_per1|
              menu_per_ids.push(menu_per1.id)
            end
          end
        end
        @menu_permission_ids = menu_per_ids
        p @menu_permission_ids
      end
      # @menu_p = @menu
      # role_tree = @role2.get_zTree.as_json
      # p role_tree
      # p params[:parent_menu]
      # p params[:parent_menu]['id']
      # curr_tree = nil
      # role_tree.each do |tree|
      #   if tree['id'] == params[:parent_menu]['id'].to_i
      #     curr_tree = tree
      #     p curr_tree
      #   end
      # end
      # menus = []
      # menu = {id:curr_tree['id'],name:curr_tree['name'],pId:curr_tree['pId'],menu_permission_id:curr_tree['menu_permission_id']}
      # menus.push(menu)
      # menus = loop_get_tree(menus,curr_tree.as_json)
      # p menus
      # menus.each do |menu|
      #   @menu_permission_ids = get_menu_per(menus,menu,menu_id,@menu_permission_ids)
      # end
      @role_menu_permissions = Role2sMenuPermission.where(role2_id:role_id,menu_permission_id: @menu_permission_ids)
      if !@role_menu_permissions.empty?
        @role_menu_permissions.each do |role_menu_permission|
          role_menu_permission.destroy
        end
      end
    end


    render :json => {success:true}
    end

  def get_menu_per(menus,menu,menu_id,result)  #循环遍历菜单树,找出当前结点中所有父结点中只有一个子结点的menu_permission_id
      p menu
      p 'a'
      p menu[:pId]
      p menu[:name]
      p menu_id.to_i
      pId_menus = []
      if menu[:id].to_i == menu_id.to_i && !menu[:pId].nil?
        p 'b'
        p menu[:name]
        menus.each do |menu2|
          if menu2[:pId] ==  menu[:pId]
            pId_menus.push(menu2)
          end
        end
      end
      if pId_menus.length==1
        menus.each do |menu3|
          if menu3[:id] == pId_menus[0][:pId]
            result.concat(menu3[:menu_permission_id])
            get_menu_per(menus,menu3,pId_menus[0][:pId],result)
          end
        end

      end
    return result
    end   #在remove_nodes中调用

  def loop_get_tree(menus,node)     #在remove_nodes中调用  　获得当前删除结点所在整个菜单树
    if !node['children'].nil? && node['children'] != []
      node['children'].each do |child_node|
        child_tree = {id:child_node['id'],name:child_node['name'],pId:child_node['pId'],menu_permission_id:child_node['menu_permission_id']}
        menus.push(child_tree)
        loop_get_tree(menus,child_node)
      end
    end
    return menus
  end

  def remove_nodes2
    p params[:data]
    param_id = params[:data]['id']
    p params[:data]['name']
    str = "_"
    if param_id.include? str
      @menu_per = MenuPermission.find_by(id:params[:data]['menu_permission_id'])
      @menu_per.update(priority_id:nil)
    else
      @menu = Menu.find_by(id:param_id)
      if !@menu.nil?
        # if !@menu.child_menus.empty?
        #   @menu.child_menus.each do |menu|
        #     menu.destroy
        #   end
        # end
        @menu.destroy
      end
    end
    render :json => {success:true}
  end

  def menus_to_user
    render template: menus_to_user
  end

  def permissions_list

  end
  # GET /menus/1
  # GET /menus/1.json
  def show
  end

  # GET /menus/new
  def new
    @menu = Menu.new
    @hospitals = Hospital.all
    # @departments = Department.all
    @menus = Menu.all
    @priorities = Priority.all
    render partial: 'menus/form'

  end

  # GET /menus/1/edit
  def edit
    @menu = Menu.find(params[:id])
    @hospitals = Hospital.all
    if !@menu.menu_permissions.first.nil?
      @departments = Department.where(hospital_id:@menu.menu_permissions.first.hospital_id)
    end
    @menus = Menu.all
    @priorities = Priority.all
    render partial: 'menus/form'
  end

  def get_department
    @departments = Department.where(hospital_id:params[:hospital_id])
    render partial: 'menus/form_department'
  end

  # POST /menus
  # POST /menus.json
  def create
    name=params[:name]
    parent_id = params[:parent_id]
    @parent_menus = Menu.where(name:name,parent_id:parent_id)
    if name != ''
      if @parent_menus.empty?
        hospital_id = params[:hospital_id]
        department_id = params[:department_id]
        parent_menu = Menu.where(id:params[:parent_name].to_i).first
        if !parent_menu.nil?
          parent_id = parent_menu.id
        end
        uri = params[:uri]
        priority_ids = []
        if !params[:priorities].nil?
          priority_ids  = params[:priorities].split(',')
        end
        if !params[:priority].nil?
          priority_ids =  params[:priority]
        end
        @par_menu = Menu.find_by(id:parent_id)
        if !@par_menu.parent_menu.nil? && (@par_menu.parent_menu.name=='医生管理' || @par_menu.parent_menu.name=='患者管理')
          @menu = Menu.create(name:name,parent_id:parent_id,uri:uri,is_show:1)
        else
          @menu = Menu.create(name:name,parent_id:parent_id,uri:uri)
        end
        if priority_ids != '' && priority_ids != []
          priority_ids.each do |priority_id|
            MenuPermission.create(menu_id:@menu.id,hospital_id:hospital_id,department_id:department_id,priority_id:priority_id)
          end
        else
          MenuPermission.create(menu_id:@menu.id,hospital_id:hospital_id,department_id:department_id)
        end
        menu_permissions = @menu.menu_permissions
        @menus = []
        @p_menus = []
        @priorities = []
        menu_permissions.each do |menu_permission|
          @menu = menu_permission.menu
          if !@menu.nil?
            priority = menu_permission.priority
            @priority = {menu_id:@menu.id,priority:priority,menu_permission_id:menu_permission.id}.as_json
            @menu={id:@menu.id,name:@menu.name,pId:@menu.parent_id,menu_permission_id:menu_permission.id,uri:@menu.uri}.as_json
            @p_menus.push(@menu)
            @priorities.push(@priority)
          end
        end
        @p_menus.each do |menu|
          child = []
          menu_permission_id = []
          @priorities.each do |pri|
            if pri['menu_id'] == menu['id']
              if !pri['priority'].nil?
                child.push({id:menu['id'].to_s+'_'+pri['priority']['id'].to_s,name:pri['priority']['name'],menu_permission_id:[pri['menu_permission_id']]})
              end
              menu_permission_id.push(pri['menu_permission_id'])
            end
          end
          @menu = {id:menu['id'],name:menu['name'],pId:menu['pId'],menu_permission_id:menu_permission_id,uri:menu['uri'],children:child}.as_json
          @menus.push(@menu)
        end
        @menus=@menus.uniq
        render :json => {success:true,data:@menus}
      else
        render :json => {success:false,data:'菜单名称与同级已有菜单重复!'}
      end
    else
      render :json => {success:false,data:'菜单名称不能为空!'}
    end

    # respond_to do |format|
    #   if @menu.save
    #     format.html { redirect_to @menu, notice: 'Menu was successfully created.' }
    #     format.json { render :show, status: :created, location: @menu }
    #   else
    #     format.html { render :new }
    #     format.json { render json: @menu.errors, status: :unprocessable_entity }
    #   end
    # end
  end

  # PATCH/PUT /menus/1
  # PATCH/PUT /menus/1.json
  def update
    @menu = Menu.find_by(id:params[:id])
    name=params[:name]
    hospital_id = params[:hospital_id]
    department_id = params[:department_id]
    parent_menu = Menu.where(id:params[:parent_name].to_i).first
    if !parent_menu.nil?
      parent_id = parent_menu.id
    end
    uri = params[:uri]
    priority_ids  = params[:priorities].split(',')
    if !@menu.nil?
      @menu.update(name:name,parent_id:parent_id,uri:uri)
      @menu_permissions = MenuPermission.where(menu_id: params[:id])
      if !@menu_permissions.empty?
        @menu_permissions.each do |menu_permission|
          hospital_id = menu_permission.hospital_id
          department_id = menu_permission.department_id
          menu_permission.destroy
        end
      end
      priority_ids.each do |priority_id|
        MenuPermission.create(menu_id:@menu.id,hospital_id:hospital_id,department_id:department_id,priority_id:priority_id)
      end
    end
    render :json => {:success => true}
    # if @menu.update(menu_params)
    #   render :json => {:success => true}
    # else
    #   render :json => {:success => false, :errors => '修改失败！'}
    # end
    # respond_to do |format|
    #   if @menu.update(menu_params)
    #     format.html { redirect_to @menu, notice: 'Menu was successfully updated.' }
    #     format.json { render :show, status: :ok, location: @menu }
    #   else
    #     format.html { render :edit }
    #     format.json { render json: @menu.errors, status: :unprocessable_entity }
    #   end
    # end
  end

  def update_name
    @menu = Menu.find_by(id:params[:id])
    if !@menu.nil?
      @menu.update(name:params[:name])
    end
    render json: @menu
  end

  # DELETE /menus/1
  # DELETE /menus/1.json
  def destroy
    @menu = Menu.find_by(id:params[:id])
    if !@menu.nil? && @menu.destroy
      render :json => {:success => true}
    end
    # @menu.destroy
    # respond_to do |format|
    #   format.html { redirect_to menus_url, notice: 'Menu was successfully destroyed.' }
    #   format.json { head :no_content }
    # end
  end

  def form_name
    @hospitals = Hospital.all
    render partial: 'menus/form_name'
  end
  def form_parent_menu
    @menus = Menu.all
    render partial: 'menus/form_parent_menu'
  end
  def form_priority
    @priorities = Priority.all
    render partial: 'menus/form_priority'
  end

  # 左侧导航
  def left_menu
    admin_id=params[:admin_id]
    Menu.new.left_menu admin_id
  end
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_menu
      @menu = Menu.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def menu_params
      params.permit(:name, :parent_id,:uri, :table_name, :model_class)
    end
end
