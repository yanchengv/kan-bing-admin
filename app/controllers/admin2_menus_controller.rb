class Admin2MenusController < ApplicationController
  before_action :set_admin2_menu, only: [:show, :edit, :update, :destroy]

  # GET /admin2_menus
  # GET /admin2_menus.json
  def index
    @admin2_menus = Admin2Menu.all
  end


  # GET /admin2_menus/1
  # GET /admin2_menus/1.json
  def show
  end

  # GET /admin2_menus/new
  def new
    @admin2_menu = Admin2Menu.new
  end

  # GET /admin2_menus/1/edit
  def edit
  end

  # POST /admin2_menus
  # POST /admin2_menus.json
  def create
    menu_ids=[]
    data=params[:data]
    admin_id=params['admin_id']
       data.each do |node|
           childrens= node[1]['children']
           menu_ids.push(node[1]['id'])
           if !childrens.nil?
              childrens.each do |children|
                menu_ids.push(children[1]['id'])
              end

           end
       end
    menu_ids.each do |menu_id|
      @admin2_menu = Admin2Menu.new(admin2_id:admin_id   ,menu_id:menu_id)
      @admin2_menu.save
    end
    render json:{flag:true}
    # respond_to do |format|
    #   if @admin2_menu.save
    #     format.html { redirect_to @admin2_menu, notice: 'Admin2 menu was successfully created.' }
    #     format.json { render :show, status: :created, location: @admin2_menu }
    #   else
    #     format.html { render :new }
    #     format.json { render json: @admin2_menu.errors, status: :unprocessable_entity }
    #   end
    # end
  end
  def delete_nodes
   node_ids=params[:data]
   admin_id=params[:admin_id]
   node_ids.each do |node_id|
     Admin2Menu.destroy_all(["admin2_id=? AND(menu_id=?)",admin_id,node_id])
end

    render json:{flag:true}
  end
  # PATCH/PUT /admin2_menus/1
  # PATCH/PUT /admin2_menus/1.json
  def update
    respond_to do |format|
      if @admin2_menu.update(admin2_menu_params)
        format.html { redirect_to @admin2_menu, notice: 'Admin2 menu was successfully updated.' }
        format.json { render :show, status: :ok, location: @admin2_menu }
      else
        format.html { render :edit }
        format.json { render json: @admin2_menu.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin2_menus/1
  # DELETE /admin2_menus/1.json
  def destroy
    @admin2_menu.destroy
    respond_to do |format|
      format.html { redirect_to admin2_menus_url, notice: 'Admin2 menu was successfully destroyed.' }
      format.json { head :no_content }
    end

  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_admin2_menu
      @admin2_menu = Admin2Menu.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def admin2_menu_params
      params.require(:admin2_menu).permit(:admin2_id, :menu_id)
    end
end
