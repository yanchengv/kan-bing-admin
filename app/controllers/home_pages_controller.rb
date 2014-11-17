class HomePagesController < ApplicationController
  before_action :set_home_page, only: [:show, :edit, :update, :destroy]

  # GET /home_pages
  # GET /home_pages.json
  def index
    render :partial => 'home_pages/home_pages_manage'
  end

  def show_index
    sql = 'true'
    hos_id = current_user.hospital_id
    dep_id = current_user.department_id
    if !hos_id.nil? && hos_id != ''
      if !dep_id.nil? && dep_id != ''
        sql << " and hospital_id=#{hos_id} and department_id=#{dep_id}"
      else
        sql << " and hospital_id=#{hos_id}"
      end
    end
    @home_pages = HomePage.where(sql)
    count = @home_pages.count
    totalpages = count % params[:rows].to_i == 0 ? count / params[:rows].to_i : count / params[:rows].to_i + 1
    @home_pages = @home_pages.limit(params[:rows].to_i).offset(params[:rows].to_i*(params[:page].to_i-1))
    render :json => {:home_pages => @home_pages.as_json, :totalpages => totalpages, :currpage => params[:page].to_i, :totalrecords => count}
  end
  #操作转向
  def oper_action
    if params[:oper] == 'del_que'
      destroy_que
    elsif params[:oper] == 'del'
      set_home_page
      destroy
    elsif params[:oper] == 'del_res'
     destroy_res
    end
  end
  # GET /home_pages/1
  # GET /home_pages/1.json
  def show
    if current_user.admin_type == '医院管理员'
      @left_menus=[{name: "医生管理", uri: "/doctors"}, {name: "患者管理", uri: "/patients"}, {name: "用户管理", uri: "/users"}, {name: "管理员管理", uri: "/admin2s"}, {name: "医院管理", uri: "/hospitals"}, {name: "教育视频管理", uri: "/edu_videos"}, {name: "留言管理", uri: "/consult_accuses"}, {name: "首页管理", uri: "", children: [{name: "首界面管理", uri: "/home_pages"}, {name: "首界面区块管理", uri: "/page_blocks"}]}]
    elsif current_user.admin_type == '科室管理员'
      @left_menus=[{name: "医生管理", uri: "/doctors"}, {name: "患者管理", uri: "/patients"}, {name: "用户管理", uri: "/users"}, {name: "教育视频管理", uri: "/edu_videos"}, {name: "留言管理", uri: "/consult_accuses"}, {name: "首页管理", uri: "", children: [{name: "首界面管理", uri: "/home_pages"}, {name: "首界面区块管理", uri: "/page_blocks"}]}]
    else
      @left_menus=Menu.new.left_menu admin_id
    end
  end

  # GET /home_pages/new
  def new
    @home_page = HomePage.new
    @hospitals = Hospital.all
    @departments = Department.all
    render :partial => 'home_pages/new'
  end

  # GET /home_pages/1/edit
  def edit
    @menus=current_user.admin2_menus
    admin_id=current_user.id
    @kindeditor=true
    @hospitals = Hospital.all
    @departments = Department.all
    if current_user.admin_type == '医院管理员'
      @left_menus=[{name: "医生管理", uri: "/doctors"}, {name: "患者管理", uri: "/patients"}, {name: "用户管理", uri: "/users"}, {name: "管理员管理", uri: "/admin2s"}, {name: "医院管理", uri: "/hospitals"}, {name: "教育视频管理", uri: "/edu_videos"}, {name: "留言管理", uri: "/consult_accuses"}, {name: "首页管理", uri: "", children: [{name: "首界面管理", uri: "/home_pages"}, {name: "首界面区块管理", uri: "/page_blocks"}]}]
    elsif current_user.admin_type == '科室管理员'
      @left_menus=[{name: "医生管理", uri: "/doctors"}, {name: "患者管理", uri: "/patients"}, {name: "用户管理", uri: "/users"}, {name: "教育视频管理", uri: "/edu_videos"}, {name: "留言管理", uri: "/consult_accuses"}, {name: "首页管理", uri: "", children: [{name: "首界面管理", uri: "/home_pages"}, {name: "首界面区块管理", uri: "/page_blocks"}]}]
    else
      @left_menus=Menu.new.left_menu admin_id
    end
   # render :partial => 'home_pages/edit'
  end

  # POST /home_pages
  # POST /home_pages.json
  def create
    respond_to do |format|
      @home_page = HomePage.new(params[:home_page].permit(:id, :name, :content, :created_id, :created_name, :updated_id, :updated_name, :hospital_id, :hospital_name, :department_id, :department_name))
      if @home_page.save
        format.html { redirect_to @home_page, notice: 'HomePage was successfully created.' }
        format.json { render :show, status: :created, location: @home_page }
      else
        format.html { render :new }
        format.json { render json: @home_page.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /home_pages/1
  # PATCH/PUT /home_pages/1.json
  def update
    respond_to do |format|
      if @home_page.update(params[:home_page].permit(:id, :name, :content, :created_id, :created_name, :updated_id, :updated_name, :hospital_id, :hospital_name, :department_id, :department_name))
        format.html { redirect_to @home_page, notice: 'HomePage was successfully updated.' }
        format.json { render :show, status: :ok, location: @home_page }
      else
        format.html { render :edit }
        format.json { render json: @home_page.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /home_pages/1
  # DELETE /home_pages/1.json
  def destroy
    if @home_page.destroy
      render :json => {:success => true}
    end
    #@home_page.destroy
    #respond_to do |format|
    #  format.html { redirect_to home_pages_url, notice: 'HomePage was successfully destroyed.' }
    #  format.json { head :no_content }
    #end
  end

  def upload
    file=params[:imgFile]
    tmpfile = getFileName(file.original_filename.to_s)
    uuid = upload_video_img_bucket(file)
    url = "http://note-upload.oss-cn-beijing.aliyuncs.com/" << uuid
    if true
      render :text => ({:error => 0, :url => url}.to_json)
    else
      render :text => ({:error => "上传失败", :url => ""}.to_json)
    end
  end

  def home_page_manage
    @menus=current_user.admin2_menus
    admin_id=current_user.id
    @kindeditor=true
    @home_page = HomePage.new
    @hospitals = Hospital.all
    @departments = Department.all
    if current_user.admin_type == '医院管理员'
      @left_menus=[{name: "医生管理", uri: "/doctors"},{name: "患者管理", uri: "/patients"},{name: "用户管理", uri: "/users"},{name: "管理员管理", uri: "/admin2s"},{name: "医院管理", uri: "/hospitals"},{name: "教育视频管理", uri: "/edu_videos"},{name:"留言管理",uri:"/consult_accuses"},{name:"首页管理",uri:"",children:[{name:"首界面管理",uri:"/home_pages"},{name:"首界面区块管理",uri:"/page_blocks"}]}]
    elsif current_user.admin_type == '科室管理员'
      @left_menus=[{name: "医生管理", uri: "/doctors"},{name: "患者管理", uri: "/patients"},{name: "用户管理", uri: "/users"},{name: "教育视频管理", uri: "/edu_videos"},{name:"留言管理",uri:"/consult_accuses"},{name:"首页管理",uri:"",children:[{name:"首界面管理",uri:"/home_pages"},{name:"首界面区块管理",uri:"/page_blocks"}]}]
    else
      @left_menus=Menu.new.left_menu admin_id
    end
  end
  private
  # Use callbacks to share common setup or constraints between actions.
  def set_home_page
    @home_page = HomePage.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def home_page_params
    params.permit(:id, :name, :content, :created_id, :created_name, :updated_id, :updated_name, :hospital_id, :hospital_name, :department_id, :department_name)
  end
end

