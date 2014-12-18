class Role2MenusController < ApplicationController
  before_filter :signed_in_user
  before_action :set_role2_menu, only: [:show, :edit, :update, :destroy]

  # GET /role2_menus
  # GET /role2_menus.json
  def index
    @role2_menus = Role2Menu.all
  end

  # GET /role2_menus/1
  # GET /role2_menus/1.json
  def show
  end

  # GET /role2_menus/new
  def new
    @role2_menu = Role2Menu.new
  end

  # GET /role2_menus/1/edit
  def edit
  end

  # POST /role2_menus
  # POST /role2_menus.json
  def create
    p_role_id = params[:targetNode]['id']
    role_id = p_role_id[p_role_id.index('-')+1,p_role_id.length]
    all_nodes = params[:data]
    all_nodes.each do |node|
      menu_id = node[1]['id']
      role2_menu_params = {role2_id:role_id,menu_id:menu_id}
      @role_menus = Role2Menu.where(role2_menu_params)
      if @role_menus.empty?
        Role2Menu.create(role2_menu_params)
      end
    end
    render :json => {success:true}
    # respond_to do |format|
    #   if @role2_menu.save
    #     format.html { redirect_to @role2_menu, notice: 'Role2 menu was successfully created.' }
    #     format.json { render :show, status: :created, location: @role2_menu }
    #   else
    #     format.html { render :new }
    #     format.json { render json: @role2_menu.errors, status: :unprocessable_entity }
    #   end
    # end
  end

  # PATCH/PUT /role2_menus/1
  # PATCH/PUT /role2_menus/1.json
  def update
    respond_to do |format|
      if @role2_menu.update(role2_menu_params)
        format.html { redirect_to @role2_menu, notice: 'Role2 menu was successfully updated.' }
        format.json { render :show, status: :ok, location: @role2_menu }
      else
        format.html { render :edit }
        format.json { render json: @role2_menu.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /role2_menus/1
  # DELETE /role2_menus/1.json
  def destroy
    node_id =  params[:data]['id']
    p_role_id = params[:targetNode]['id']
    role_id = p_role_id[p_role_id.index('-')+1,p_role_id.length]
    if node_id.include? 'role-'
      role2_id = node_id[node_id.index('-')+1,node_id.length]
      @role = Role2.where(id:role2_id).first
      if !@role.nil?
        @role.destroy
      end
    else
      @role_menus = Role2Menu.where(role2_id: role_id,menu_id: node_id)
      if !@role_menus.empty?
        @role_menus.each do |role_menu|
          role_menu.destroy
        end
      end
    end
    render json: {success:true}
  end

  def menus_to_roles
    role2 = Role2.new
    @all_menus = role2.root_tree(Menu.all)
    @total_menus = {name:'菜单列表',children:@all_menus,open:true}
    @all_role= Role2.all
    @all_roles=[]
    @all_role.each do |role|
      if role.menu_tree == []
        @role = {id:'role-'+role.id.to_s,name:role.name,pId:0,code:role.code,instruction:role.instruction,open:true}
      else
        @role = {id:'role-'+role.id.to_s,name:role.name,pId:0,code:role.code,instruction:role.instruction,children:role.menu_tree,open:true}
      end
      @all_roles.push(@role)
    end
    @all_roles = {name:'角色列表',children:@all_roles,open:true}
    render partial: 'role2_menus/menus_to_roles'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_role2_menu
      @role2_menu = Role2Menu.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def role2_menu_params
      params.require(:role2_menu).permit(:role2_id, :menu_id)
    end
end
