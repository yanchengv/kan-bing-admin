class PageBlocksController < ApplicationController
  before_action :set_page_block, only: [:show, :edit, :update, :destroy]

  # GET /page_blocks
  # GET /page_blocks.json
  def index
    render :partial => 'page_blocks/page_blocks_manage'
  end

  def show_index
    sql = 'true'
    #hos_id = current_user.hospital_id
    #dep_id = current_user.department_id
    #if !hos_id.nil? && hos_id != ''
    #  if !dep_id.nil? && dep_id != ''
    #    sql << " and hospital_id=#{hos_id} and department_id=#{dep_id}"
    #  else
    #    sql << " and hospital_id=#{hos_id}"
    #  end
    #end
    @page_blocks = PageBlock.where(sql).order('created_at desc')
    count = @page_blocks.count
    totalpages = count % params[:rows].to_i == 0 ? count / params[:rows].to_i : count / params[:rows].to_i + 1
    @page_blocks = @page_blocks.limit(params[:rows].to_i).offset(params[:rows].to_i*(params[:page].to_i-1))
    render :json => {:page_blocks => @page_blocks.as_json, :totalpages => totalpages, :currpage => params[:page].to_i, :totalrecords => count}
  end

  #操作转向
  def oper_action
    if params[:oper] == 'del_que'
      destroy_que
    elsif params[:oper] == 'del'
      set_page_block
      destroy
    elsif params[:oper] == 'del_res'
      destroy_res
    end
  end

  # GET /page_blocks/1
  # GET /page_blocks/1.json
  def show
   render :partial => 'page_blocks/show'
  end

  # GET /page_blocks/new
  def new
    @page_block = PageBlock.new
    @home_pages = HomePage.all
    render :partial => 'page_blocks/new'
  end

  # GET /page_blocks/1/edit
  def edit
    @kindeditor=true
    menu_list
    @home_pages = HomePage.all
  end

  def page_blocks_manage
    @menus=current_user.admin2_menus
    admin_id=current_user.id
    @kindeditor=true
    @page_block = PageBlock.new
    @home_pages = HomePage.all
    if current_user.admin_type == '医院管理员'
      @left_menus=[{name: "医生管理", uri: "/doctors"}, {name: "患者管理", uri: "/patients"}, {name: "用户管理", uri: "/users"}, {name: "管理员管理", uri: "/admin2s"}, {name: "医院管理", uri: "/hospitals"}, {name: "教育视频管理", uri: "/edu_videos"}, {name: "留言管理", uri: "/consult_accuses"}, {name: "首页管理", uri: "", children: [{name: "首界面管理", uri: "/home_pages"}, {name: "首界面区块管理", uri: "/page_blocks"}]}]
    elsif current_user.admin_type == '科室管理员'
      @left_menus=[{name: "医生管理", uri: "/doctors"}, {name: "患者管理", uri: "/patients"}, {name: "用户管理", uri: "/users"}, {name: "教育视频管理", uri: "/edu_videos"}, {name: "留言管理", uri: "/consult_accuses"}, {name: "首页管理", uri: "", children: [{name: "首界面管理", uri: "/home_pages"}, {name: "首界面区块管理", uri: "/page_blocks"}]}]
    else
      @left_menus=Menu.new.left_menu admin_id
    end
  end

  # POST /page_blocks
  # POST /page_blocks.json
  def create
      @page_block = PageBlock.new(page_block_params)
      if current_user
        @page_block.hospital_id = current_user.hospital_id
        @page_block.department_id = current_user.department_id
        @page_block.created_id = current_user.id
        @page_block.created_name = current_user.name
      end
      if @page_block.content.include? '区块名称'
        @page_block.content = @page_block.content.sub!('区块名称', @page_block.name)
      end
      if @page_block.save
        if @page_block.content.include? 'user_login'
          redirect_to :action => :show, :id => @page_block.id
        else
          if @page_block.content.include? 'title_list' || (@page_block.content.include? 'block_text')
            render :partial => 'block_contents/block_contents_manage', :object => @page_block

          elsif @page_block.content.include? 'picture_list' || (@page_block.content.include? 'show_list')
            render :partial => 'block_contents/picture_list_manage', :object => @page_block
          else
           render :partial => 'block_contents/block_doctors_manage', :object => @page_block
          end
        end
      else
        redirect_to :action => :new
      end
  end

  # PATCH/PUT /page_blocks/1
  # PATCH/PUT /page_blocks/1.json
  def update
    if current_user
      @page_block.updated_id = current_user.id
      @page_block.updated_name = current_user.name
    end
    respond_to do |format|
      if @page_block.update(page_block_params)
        format.html { redirect_to @page_block, notice: 'PageBlock was successfully updated.' }
        format.json { render :show, status: :ok, location: @page_block }
      else
        format.html { render :edit }
        format.json { render json: @page_block.errors, status: :unprocessable_entity }
      end
    end
  end

  # 展现界面排版的页面
  def page_blocks_setting
    hospital_id=current_user.hospital_id
    department_id=current_user.hospital_id
    @page_block=PageBlock.where('hospital_id=? AND department_id=? AND is_show=?', hospital_id, department_id, true).order(position: :asc)
    @hospital_id=hospital_id
    @department_id=department_id
    render partial: 'page_blocks/page_blocks_setting'
  end

  # 修改排版位置
  def update_position
    if !params[:pageBlogIds].nil?
      page_block_ids=params[:pageBlogIds].split(",")
      page_block_ids.each_with_index { |page_block_id, index|
        @page_block=PageBlock.where(id: page_block_id).first
        @page_block.update(position: index+1)
      }
    end
    hospital_id=params[:hospital_id]
    department_id=params[:department_id]
    @page_block=PageBlock.where('hospital_id=? AND department_id=? AND is_show=?', hospital_id, department_id, true).order(position: :asc)
    @hospital_id=hospital_id
    @department_id=department_id
    render partial: 'page_blocks/page_blocks_setting'
  end

  # DELETE /page_blocks/1
  # DELETE /page_blocks/1.json
  def destroy
    if @page_block.destroy
      render :json => {:success => true}
    end
    #@page_block.destroy
    #respond_to do |format|
    #  format.html { redirect_to page_blocks_url, notice: 'PageBlock was successfully destroyed.' }
    #  format.json { head :no_content }
    #end
  end

  def menu_list
    @menus=current_user.admin2_menus
    admin_id=current_user.id
    @kindeditor=true
    if current_user.admin_type == '医院管理员'
      @left_menus=[{name: "医生管理", uri: "/doctors"}, {name: "患者管理", uri: "/patients"}, {name: "用户管理", uri: "/users"}, {name: "管理员管理", uri: "/admin2s"}, {name: "医院管理", uri: "/hospitals"}, {name: "教育视频管理", uri: "/edu_videos"}, {name: "留言管理", uri: "/consult_accuses"}, {name: "首页管理", uri: "", children: [{name: "首界面管理", uri: "/page_blocks/page_blocks_setting"}, {name: "首界面区块管理", uri: "/page_blocks"}]}]
    elsif current_user.admin_type == '科室管理员'
      @left_menus=[{name: "医生管理", uri: "/doctors"}, {name: "患者管理", uri: "/patients"}, {name: "用户管理", uri: "/users"}, {name: "教育视频管理", uri: "/edu_videos"}, {name: "留言管理", uri: "/consult_accuses"}, {name: "首页管理", uri: "", children: [{name: "首界面管理", uri: "/page_blocks/page_blocks_setting"}, {name: "首界面区块管理", uri: "/page_blocks"}]}]
    else
      @left_menus=Menu.new.left_menu admin_id
    end
  end

  #修改是否显示的状态
  def change_is_show
    if params[:id] && params[:is_show]
      @page_block = PageBlock.find(params[:id])
      @page_block.update_attribute(:is_show, params[:is_show])
      render :json => {:success => true}
    else
      render :json => {:success => false, :errors => '修改失败！'}
    end
  end

  #动态样式的添加
  def dynamic_style(content, urls)
    str = content
    if !urls.nil? && !urls.empty? && urls != ''
      urls = urls.split(',')
      if content.include? 'picture_list'
        len = content.scan('图片').length
        for i in 0..(len-1) do
          if i >= urls.size
            str = str.sub!('图片', "<img src='#{urls[i-urls.size*(len / urls.size)]}' />")
          else
            str = str.sub!('图片', "<img src='#{urls[i]}' />")
          end
        end
      elsif content.include? 'doctor_list_d'
        @doctor = Doctor.find(urls[0])
        if @doctor
          if @doctor.photo
            photo_url = "http://mimas-open.oss-cn-hangzhou.aliyuncs.com/#{@doctor.photo}"
          else
            photo_url = "http://dev-mimas.oss-cn-beijing.aliyuncs.com/f181f3be-f34c-40c2-8c7e-3546567ce42d.png"
          end
          str = content.sub!('医生照片', "<a href='#' onclick='showDoctorPage(#{@doctor.id}, \"str\");return false;' target='_blank'><img alt='#{@doctor.name}' style='width:75px;height:99px' id='img_url' src='#{photo_url}' title='#{@doctor.name}'></a>")
          .sub!('医生姓名', @doctor.name)
          .sub!('所属医院', @doctor.hospital.nil? ? '' : @doctor.hospital.name)
          .sub!('所属科室', @doctor.department.nil? ? '' : @doctor.department.name)
          .sub!('医生简介', @doctor.introduction)
        end

        pc = content.scan('头像').length
        for j in 0..(pc-1) do
          if j >= urls.size
            doc = Doctor.find(urls[j-urls.size*(pc / urls.size)])
          else
            doc = Doctor.find(urls[j])
          end
          if doc.photo
            photo_url = "http://mimas-open.oss-cn-hangzhou.aliyuncs.com/#{doc.photo}"
          else
            photo_url = "http://dev-mimas.oss-cn-beijing.aliyuncs.com/f181f3be-f34c-40c2-8c7e-3546567ce42d.png"
          end
          str = str.sub!('头像', "<a class='pl' href='#' onclick='showDoctorPage(#{doc.id}, \"\");return false;' target='_blank'><img alt='#{doc.name}' style='width:55px;height:77 px' onmouseover=\"change_doctor(
          '#{photo_url}',
              '#{doc.introduction}',
              '#{doc.name}',
              '#{doc.hospital.nil? ? '' : doc.hospital.name}',
              '#{doc.department.nil? ? '' : doc.department.name}',
              #{doc.id});return false;\" src='#{photo_url}' title='#{doc.name}'></a>")
        end
      else
        str = content
      end
    end

    return str
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_page_block
    @page_block = PageBlock.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def page_block_params
    params[:page_block].permit(:id, :name, :content, :created_id, :created_name, :updated_id, :updated_name, :hospital_id, :hospital_name, :department_id, :department_name, :page_id, :position, :is_show)
  end
end

