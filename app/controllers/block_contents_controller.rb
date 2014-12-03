class BlockContentsController < ApplicationController
  before_filter :signed_in_user
  before_action :set_block_content, only: [:show, :edit, :update, :destroy]

  # GET /block_contents
  # GET /block_contents.json
  def index
    render :partial => 'block_contents/block_contents_manage'
  end

  def show_index
    @block_contents = BlockContent.where(:block_id => params[:block_id])
    count = @block_contents.count
    totalpages = count % params[:rows].to_i == 0 ? count / params[:rows].to_i : count / params[:rows].to_i + 1
    @block_contents = @block_contents.limit(params[:rows].to_i).offset(params[:rows].to_i*(params[:page].to_i-1))
    render :json => {:block_contents => @block_contents.as_json, :totalpages => totalpages, :currpage => params[:page].to_i, :totalrecords => count}
  end

  def oper_action
    if params[:oper] == 'add'
      create
    elsif params[:oper] == 'del'
      set_block_content
      destroy
    elsif params[:oper] == 'edit'
      set_block_content
      update
    end
  end

  # GET /block_contents/1
  # GET /block_contents/1.json
  def show
  end

  # GET /block_contents/new
  def new
    @block_content = BlockContent.new
  end

  # GET /block_contents/1/edit
  def edit
  end

  # POST /block_contents
  # POST /block_contents.json
  def create
    @block_content = BlockContent.new(block_content_params)
    if @block_content.save
      render :json => {:success => true}
    else
      render :json => {:success => false, :errors => '添加失败！'}
    end

    #respond_to do |format|
    #  if @block_content.save
    #    format.html { redirect_to @block_content, notice: 'Admin was successfully created.' }
    #    format.json { render :show, status: :created, location: @block_content }
    #  else
    #    format.html { render :new }
    #    format.json { render json: @block_content.errors, status: :unprocessable_entity }
    #  end
    #end
  end

  ##保存内容到区块
  #def save_content_to_block
  #  @page_block = PageBlock.find(params[:block_id])
  #  if @page_block
  #    content = @page_block.content
  #    ids = params[:ids]
  #    if content.include? 'doctor_list_d'
  #      @doctor = Doctor.find(ids[0])
  #      if @doctor
  #        if @doctor.photo
  #          photo_url = "http://mimas-open.oss-cn-hangzhou.aliyuncs.com/#{@doctor.photo}"
  #        else
  #          photo_url = "http://dev-mimas.oss-cn-beijing.aliyuncs.com/f181f3be-f34c-40c2-8c7e-3546567ce42d.png"
  #        end
  #        content = content.sub!('医生照片', "<a href='#' onclick='showDoctorPage(#{@doctor.id}, \"str\");return false;' target='_blank'><img alt='#{@doctor.name}' style='width:75px;height:99px' id='img_url' src='#{photo_url}' title='#{@doctor.name}'></a>")
  #        .sub!('医生姓名', @doctor.name)
  #        .sub!('所属医院', @doctor.hospital.nil? ? '' : @doctor.hospital.name)
  #        .sub!('所属科室', @doctor.department.nil? ? '' : @doctor.department.name)
  #        .sub!('医生简介', @doctor.introduction.nil? ? '' : @doctor.introduction)
  #      end
  #      ids.each do |id|
  #        doc = Doctor.find(id)
  #        if doc.photo
  #          photo_url = "http://mimas-open.oss-cn-hangzhou.aliyuncs.com/#{doc.photo}"
  #        else
  #          photo_url = "http://dev-mimas.oss-cn-beijing.aliyuncs.com/f181f3be-f34c-40c2-8c7e-3546567ce42d.png"
  #        end
  #        content = content.sub!('头像', "<a class='pl' href='#' onclick='showDoctorPage(#{doc.id}, \"\");return false;' target='_blank'><img alt='#{doc.name}' style='width:55px;height:77 px' onmouseover=\"change_doctor(
  #        '#{photo_url}',
  #            '#{doc.introduction}',
  #            '#{doc.name}',
  #            '#{doc.hospital.nil? ? '' : doc.hospital.name}',
  #            '#{doc.department.nil? ? '' : doc.department.name}',
  #            #{doc.id});return false;\" src='#{photo_url}' title='#{doc.name}'></a>")
  #      end
  #    else
  #      @block_contents = BlockContent.where(:block_id => @page_block.id)
  #      if content.include? 'title_list'
  #        content = content.sub!('more', ' ')
  #        @block_contents.each do |block_content|
  #          content = content.sub!('<a>', '<a href="'<<block_content.url<<'" >').sub!('标题内容', block_content.title).sub!('时间', block_content.create_date.to_s)
  #        end
  #      elsif content.include? 'block_text'
  #        content = content.sub!('more', ' ').sub!('内容编辑区', @block_contents.first.content )
  #      elsif @page_block.content.include? 'picture_list'
  #        @block_contents.each do |block_content|
  #          content = content.sub!('图片', '<img src="'<<block_content.url<<'"/>')
  #        end
  #      elsif @page_block.content.include? 'show_list'
  #        @block_contents.each do |block_content|
  #          content = content.sub!('图片', '<img src="'<<block_content.url<<'" />').sub!('名称', block_content.title).sub!('内容', block_content.content)
  #        end
  #      end
  #    end
  #    sql = ActiveRecord::Base.connection()
  #    sql.update "update page_blocks set content = '#{content}' where id = #{@page_block.id}"
  #    redirect_to :action => :show, :controller => 'page_blocks', :id => @page_block.id
  #  else
  #    redirect_to :action => :show, :controller => 'page_blocks', :id => @page_block.id
  #  end
  #end

  # PATCH/PUT /block_contents/1
  # PATCH/PUT /block_contents/1.json
  def update
    if @block_content.update(block_content_params)
      render :json => {:success => true}
    else
      render :json => {:success => false, :errors => '修改失败！'}
    end
    #respond_to do |format|
    #  if @block_content.update(block_content_params)
    #    format.html { redirect_to @block_content, notice: 'Admin was successfully updated.' }
    #    format.json { render :show, status: :ok, location: @block_content }
    #  else
    #    format.html { render :edit }
    #    format.json { render json: @block_content.errors, status: :unprocessable_entity }
    #  end
    #end
  end


  def save_pic
    @page_block = PageBlock.find(params[:block_id])
    render :partial => 'block_contents/save_pic'
  end

  def save_pic_content
    para={}
    para[:title]=params[:title]
    para[:content]=params[:content]
    para[:url]=params[:url]
    para[:block_id]=params[:block_id]

    @block_content=BlockContent.new(para)
    @page_block = PageBlock.find(params[:block_id])
    @block_contents = BlockContent.where(:block_id => params[:block_id])
    if @block_content.save
      render partial: "page_blocks/templates/#{@page_block.block_type}"
    else
      render :partial => 'block_contents/save_pic'
    end
  end

  def save_doctors
    para={}
    para[:content]=params[:content].to_s.gsub('[', '').gsub(']', '')
    para[:block_id]=params[:block_id]
    @block_content=BlockContent.new(para)
    @page_block = PageBlock.find(params[:block_id])
    if @block_content.save
      @doctors = Doctor.where("id in (#{@block_content.content})")
      @doctor = @doctors[0]
      render partial: "page_blocks/templates/#{@page_block.block_type}"
    else
      render :partial => 'block_contents/save_pic'
    end
  end

  # DELETE /block_contents/1
  # DELETE /block_contents/1.json
  def destroy
    if @block_content.destroy
      render :json => {:success => true}
    end
    #respond_to do |format|
    #  format.html { redirect_to block_contents_url, notice: 'Admin was successfully destroyed.' }
    #  format.json { head :no_content }
    #end
  end

  def batch_delete
    if params[:ids]
      @block_contents = BlockContent.where("id in #{params[:ids].to_s.gsub('[', '(').gsub(']', ')')}")
      if @block_contents.delete_all
        render :json => {:success => true}
      end
    end
  end

  def setting
    render template: 'block_contents/setting'
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_block_content
    @block_content = BlockContent.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def block_content_params
    params.permit(:block_name, :title, :content, :url, :block_type, :create_date, :block_id)
  end
end
