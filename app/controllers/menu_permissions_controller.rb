class MenuPermissionsController < ApplicationController
  before_filter :signed_in_user
  before_action :set_menu_permission, only: [:show, :edit, :update, :destroy]

  # GET /menu_permissions
  # GET /menu_permissions.json
  def index
    @menu_permissions = MenuPermission.all
  end

  # GET /menu_permissions/1
  # GET /menu_permissions/1.json
  def show
  end

  # GET /menu_permissions/new
  def new
    @menu_permission = MenuPermission.new
  end

  # GET /menu_permissions/1/edit
  def edit
  end

  # POST /menu_permissions
  # POST /menu_permissions.json
  def create
    @menu_permission = MenuPermission.new(menu_permission_params)

    respond_to do |format|
      if @menu_permission.save
        format.html { redirect_to @menu_permission, notice: 'Menu permission was successfully created.' }
        format.json { render :show, status: :created, location: @menu_permission }
      else
        format.html { render :new }
        format.json { render json: @menu_permission.errors, status: :unprocessable_entity }
      end
    end
  end

  def create_by_menu
    @menu = Menu.find_by(id:params[:menu_id])
    if !@menu.nil?
      @menu2 = Menu.where(name:params[:name],parent_id: @menu.parent_id).first
    end
    p @menu2
    if params[:name] == ''
      render json: {success:false,error:'菜单名不可空!'}
    elsif !@menu2.nil? && @menu2.id.to_i != params[:menu_id].to_i
      render json: {success:false,error:'菜单名重复!'}
    else
      @priorities = []
      if !@menu.nil?
        @menu.update(name:params[:name])
        if params[:priority] != ''
          priority_ids = params[:priority]
          if !@menu.menu_permissions.empty?
            @menu_per = @menu.menu_permissions.first
            @menu.menu_permissions.each do |menu_per|
              # if !menu_per.priority_id.nil? && menu_per.priority_id != ''
              #   priority_ids.push(menu_per.priority_id.to_s)
              # end
              menu_per.destroy
            end
          end
          if !@menu_per.nil?
            hos_id = @menu_per.hospital_id
            dep_id = @menu_per.department_id
          end
          p priority_ids
          p priority_ids.uniq
          priority_ids.each do |priority_id|
            @menu_permission = MenuPermission.create(menu_id:@menu.id,hospital_id:hos_id,department_id:dep_id,priority_id:priority_id)
            @priority = Priority.find_by(id:priority_id)
            priority = {id:@menu.id.to_s+'_'+priority_id,name:@priority.name,menu_permission_id:[@menu_permission.id]}
            @priorities.push(priority)
          end
        end
      end
      render json: {success:true,priorities:@priorities,menu:@menu}
    end
  end

  # PATCH/PUT /menu_permissions/1
  # PATCH/PUT /menu_permissions/1.json
  def update
    respond_to do |format|
      if @menu_permission.update(menu_permission_params)
        format.html { redirect_to @menu_permission, notice: 'Menu permission was successfully updated.' }
        format.json { render :show, status: :ok, location: @menu_permission }
      else
        format.html { render :edit }
        format.json { render json: @menu_permission.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /menu_permissions/1
  # DELETE /menu_permissions/1.json
  def destroy
    @menu_permission.destroy
    respond_to do |format|
      format.html { redirect_to menu_permissions_url, notice: 'Menu permission was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_menu_permission
      @menu_permission = MenuPermission.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def menu_permission_params
      params.require(:menu_permission).permit(:menu_id, :admin2_id, :hospital_id, :department_id, :is_show, :is_edit, :is_add, :is_delete, :is_manage)
    end
end
