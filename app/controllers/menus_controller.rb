class MenusController < ApplicationController
  require 'will_paginate/array'
  before_action :set_menu, only: [ :edit, :update, :destroy]

  # GET /menus
  # GET /menus.json


  def index

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

  def show_menus
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
    render template: 'menus/show'
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
    @total_menus = {name:'菜单及权限',children:@all_tree,open:true}
    p @total_menus
    @all_role= Role2.all
    @all_roles=[]
    @all_role.each do |role|
      p 'role'
      p role.name
      if role.get_zTree == []
        @role = {id:role.id,name:role.name,open:true}
      else
        @role = {id:role.id,name:role.name,children:role.get_zTree,open:true}
      end
      @all_roles.push(@role)
    end
    p 'a'
    @all_roles = {name:'角色管理',children:@all_roles,open:true}
    p @all_roles.as_json

    render template: 'menus/show_all_menus'
  end

  def drag
    p params[:data]
    puts 'baek'
    p params[:targetNode]
    p params[:nodes]
    role_id = params[:targetNode]['id']
    p role_id
    all_nodes = params[:data]
    all_nodes.each do |node|
      p node[1]['name']
      p node[1]['id']
      p node[1]['menu_permission_id']
      node[1]['menu_permission_id'].each do |menu_permission_id|
        @select_role_menu_pers = Role2sMenuPermission.where(role2_id:role_id,menu_permission_id:menu_permission_id)
        if @select_role_menu_pers.empty?
          @role_menu_per = Role2sMenuPermission.create(role2_id:role_id,menu_permission_id:menu_permission_id)
        end
      end
    end
    render :json => @all_roles.as_json
  end

  def remove_nodes
    p params[:targetNode]
    menu_permission_id =  params[:data]
    p menu_permission_id
    role_id = params[:targetNode]['id']
    @role_menu_permissions = Role2sMenuPermission.where(role2_id:role_id,menu_permission_id: menu_permission_id)
    if !@role_menu_permissions.empty?
      @role_menu_permissions.each do |role_menu_permission|
        role_menu_permission.destroy
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
    hospital_id = params[:hospital_id]
    department_id = params[:department_id]
    parent_menu = Menu.where(id:params[:parent_name].to_i).first
    if !parent_menu.nil?
      parent_id = parent_menu.id
    end
    uri = params[:uri]
    priority_ids  = params[:priorities].split(',')
    @menu = Menu.create(name:name,parent_id:parent_id,uri:uri)
    priority_ids.each do |priority_id|
      MenuPermission.create(menu_id:@menu.id,hospital_id:hospital_id,department_id:department_id,priority_id:priority_id)
    end
    render :json => {success:true}
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
