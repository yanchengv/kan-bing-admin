class Admin2sRole2sController < ApplicationController
  before_filter :signed_in_user
  before_action :set_admin2s_role2, only: [:show, :edit, :update, :destroy]

  # GET /admin2s_role2s
  # GET /admin2s_role2s.json
  def index
    # @admin2s_role2s = Admin2sRole2.all
    @admin2s = Admin2.all
    @role2s = Role2.all
    admin_roles = []
    if !@admin2s.empty?
      @admin2s.each do |admin|
        roles = []
        if !admin.role2s.empty?
          admin.role2s.each do |role|
            @role = {id:'role-'+role.id.to_s,name:role.name,pId:admin.id}
            roles.push(@role)
          end
        end
        @admin = {id:admin.id,name:admin.name,children:roles}
        admin_roles.push(@admin)
      end
    end
    role2s = []
    if !@role2s.empty?
      @role2s.each do |role2|
        @role2 = {id:'role-'+role2.id.to_s,name:role2.name}
        role2s.push(@role2)
      end
    end
    @role2s = {name:'系统角色',children:role2s,open:true}
    @admin2s_role2 = {name:'系统管理员',children:admin_roles,open:true}
    render partial: 'admin2s_role2s/index'
  end

  # GET /admin2s_role2s/1
  # GET /admin2s_role2s/1.json
  def show
  end

  # GET /admin2s_role2s/new
  def new
    @admin2s_role2 = Admin2sRole2.new
  end

  # GET /admin2s_role2s/1/edit
  def edit
  end

  # POST /admin2s_role2s
  # POST /admin2s_role2s.json
  def create
    p params[:sourceNode]
    p params[:targetNode]
    p_role_id = params[:sourceNode]['id']
    role_id = p_role_id[p_role_id.index('-')+1,p_role_id.length]
    admin2s_role2_params = {admin2_id:params[:targetNode]['id'],role2_id:role_id}
    @admin2s_role2s = Admin2sRole2.where(admin2s_role2_params)
    if @admin2s_role2s.empty?
      @admin2s_role2 = Admin2sRole2.new(admin2s_role2_params)
      if @admin2s_role2.save
        render json: {success:true}
      else
        render json: {success:false}
      end
    else
      render json: {success:false}
    end
    # respond_to do |format|
    #   if @admin2s_role2.save
    #     format.html { redirect_to @admin2s_role2, notice: 'Admin2s role2 was successfully created.' }
    #     format.json { render :show, status: :created, location: @admin2s_role2 }
    #   else
    #     format.html { render :new }
    #     format.json { render json: @admin2s_role2.errors, status: :unprocessable_entity }
    #   end
    # end
  end

  # PATCH/PUT /admin2s_role2s/1
  # PATCH/PUT /admin2s_role2s/1.json
  def update
    respond_to do |format|
      if @admin2s_role2.update(admin2s_role2_params)
        format.html { redirect_to @admin2s_role2, notice: 'Admin2s role2 was successfully updated.' }
        format.json { render :show, status: :ok, location: @admin2s_role2 }
      else
        format.html { render :edit }
        format.json { render json: @admin2s_role2.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin2s_role2s/1
  # DELETE /admin2s_role2s/1.json
  def destroy
    @admin2s_role2.destroy
    respond_to do |format|
      format.html { redirect_to admin2s_role2s_url, notice: 'Admin2s role2 was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def remove_nodes
    p_role_id = params[:sourceNode]['id']
    role_id = p_role_id[p_role_id.index('-')+1,p_role_id.length]
    admin2s_role2_params = {admin2_id:params[:targetNode]['id'],role2_id:role_id}
    @admin2s_role2s = Admin2sRole2.where(admin2s_role2_params)
    if !@admin2s_role2s.empty?
      @admin2s_role2s.each do |admin_role|
        admin_role.destroy
      end
    end
    render json: {success:true}
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_admin2s_role2
      @admin2s_role2 = Admin2sRole2.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def admin2s_role2_params
      params.require(:admin2s_role2).permit(:admin2_id, :role2_id)
    end
end
