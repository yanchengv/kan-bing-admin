class HomeMenuController < ApplicationController
  # 展现添加菜单极富文本的页面
  def new
    @parent_id=params['nodeId']
    @home_page=HomePage.new
    @home_menu=HomeMenu.new
    render partial:'home_menu/new'
  end

  # 新加菜单
  def create
    menu_pra={}
    home_page_pra={}
    menu_pra[:parent_id]=params['home_menu']['parent_id']
    menu_pra[:name]=params['home_menu']['name']
    menu_pra[:show_in_menu]=params['home_menu']['show_in_menu']
    menu_pra[:link_url]=params['home_menu']['link_url']
    menu_pra[:redirect_url]=params['home_menu']['redirect_url']
    menu_pra[:hospital_id]=current_user.hospital_id
    menu_pra[:department_id]=current_user.department_id

    @home_menu=HomeMenu.new(menu_pra)
    @home_menu.save

    home_page_pra[:home_menu_id]=@home_menu.id
    home_page_pra[:content]=params['home_menu']['content']
    home_page_pra[:link_url]=params['home_menu']['link_url']
    home_page_pra[:redirect_url]=params['home_menu']['redirect_url']
    home_page_pra[:hospital_id]=current_user.hospital_id
    home_page_pra[:department_id]=current_user.department_id
    @home_page=HomePage.new(home_page_pra)
    @home_page.save
    redirect_to action:'show'
  end
  def show
    all_menus
      menus=HomeMenu.where(hospital_id:current_user.hospital_id,department_id:current_user.department_id)
      # @home_menus= {name:"菜单管理",children:home_menus,open:true}
      home_menus=[]
      menus.each do |menu|
        home_menus<<{id:menu.id,pId:menu.parent_id,name:menu.name,hospital_id:menu.hospital_id,department_id:menu.department_id,open:true}
      end
      @home_menus=home_menus
     render 'home_menu/show'
  end


  # 获取编辑菜单及内容
  def edit
    node_id=params['nodeId']
    @home_menu=HomeMenu.where(id:node_id).first
    @home_page=HomePage.where(home_menu_id:node_id).first
    @home_menu_id= @home_page.home_menu_id
    render partial: 'home_menu/edit'
  end

  #  编辑后保存
  def save
    menu_pra={}
    home_page_pra={}
    menu_pra[:name]=params['home_menu']['name']
    menu_pra[:show_in_menu]=params['home_menu']['show_in_menu']
    menu_pra[:link_url]=params['home_menu']['link_url']
    menu_pra[:redirect_url]=params['home_menu']['redirect_url']

    home_menu_id=params['home_menu']['home_menu_id']

    home_page_pra[:content]=params['home_menu']['content']
    home_page_pra[:link_url]=params['home_menu']['link_url']
    home_page_pra[:redirect_url]=params['home_menu']['redirect_url']
    @home_menu=HomeMenu.where(id:home_menu_id).first
    @home_menu.update_attributes(menu_pra)


    @home_page=HomePage.where(home_menu_id:home_menu_id).first
    @home_page.update_attributes(home_page_pra)

    redirect_to action:'show'
  end

  def destroy
     id=params[:nodeId]
      @home_menu=HomeMenu.where(id:id).first
      @home_menus=HomeMenu.where(parent_id:id)
     if  @home_menu
       @home_menu.destroy
       if !@home_menus.empty?
         # 同时删除子菜单
         @home_menus.each do |menu|
           menu.destroy
         end
       end

     end
    render json:'success'
  end

  def check_url
    @home_menu = HomeMenu.where(link_url:params[:link_url]).first
    if @home_menu.nil?
      render json: {success:true}
    else
      if @home_menu.id.to_i == params[:home_menu_id].to_i
        render json: {success:true}
      else
        render json: {success:false}
      end
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_home_page
    @home_menu = HomeMenu.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def home_page_params
    params.permit(:id,:name,:parent_id,:hospital_id,:department_id,:content,:show_in_menu,:link_url,:redirect_url,:skip_to_first_child,:show_in_header,:show_in_footer,:depth)
    params.require(:home_pages).permit(:id,:home_menu_id,:name,:content,:hospital_id,:department_id,:position,:link_url,:redirect_url)

  end
end
