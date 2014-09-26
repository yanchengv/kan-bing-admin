class MenusController < ApplicationController
  before_action :set_menu, only: [ :edit, :update, :destroy]

  # GET /menus
  # GET /menus.json
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

  def menus_to_user
    render template: menus_to_user
  end
  # GET /menus/1
  # GET /menus/1.json
  def show
  end

  # GET /menus/new
  def new
    @menu = Menu.new

  end

  # GET /menus/1/edit
  def edit
  end

  # POST /menus
  # POST /menus.json
  def create
    @menu = Menu.new(menu_params)


    respond_to do |format|
      if @menu.save
        format.html { redirect_to @menu, notice: 'Menu was successfully created.' }
        format.json { render :show, status: :created, location: @menu }
      else
        format.html { render :new }
        format.json { render json: @menu.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /menus/1
  # PATCH/PUT /menus/1.json
  def update
    respond_to do |format|
      if @menu.update(menu_params)
        format.html { redirect_to @menu, notice: 'Menu was successfully updated.' }
        format.json { render :show, status: :ok, location: @menu }
      else
        format.html { render :edit }
        format.json { render json: @menu.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /menus/1
  # DELETE /menus/1.json
  def destroy
    @menu.destroy
    respond_to do |format|
      format.html { redirect_to menus_url, notice: 'Menu was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_menu
      @menu = Menu.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def menu_params
      params.require(:menu).permit(:name, :parent_id,:uri, :table_name, :model_class)
    end
end
