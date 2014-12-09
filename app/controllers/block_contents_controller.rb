class BlockContentsController < ApplicationController
  before_filter :signed_in_user
  before_action :set_block_content, only: [:show, :edit, :update, :destroy]
  skip_before_filter :oper_action
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

  #获取医生列表中的医生
  def get_doctors

    @page_block = PageBlock.find(params[:block_id])
    if !@page_block.nil?
      @block_content = @page_block.block_contents.first
      if !@block_content.nil?
        if !@block_content.content.nil? && @block_content.content != ''
          @doctors = Doctor.where("id in (#{@block_content.content})")
        else
          @doctors = Doctor.where('1 != 1')
        end
      else
        @doctors = Doctor.where('1 != 1')
      end
    else
      @doctors = Doctor.where('1 != 1')
    end
    count = @doctors.count
    totalpages = count % params[:rows].to_i == 0 ? count / params[:rows].to_i : count / params[:rows].to_i + 1
    @doctors = @doctors.limit(params[:rows].to_i).offset(params[:rows].to_i*(params[:page].to_i-1))
    render :json => {:doctors => @doctors.as_json, :totalpages => totalpages, :currpage => params[:page].to_i, :totalrecords => count}
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
    @page_block = PageBlock.find(@block_content.block_id)
    render :partial => 'block_contents/edit_pic'
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

  def update
    para={}
    para[:title]=params[:title]
    para[:content]=params[:content]
    para[:url]=params[:url]
    if @block_content.update(para)
      @page_block = PageBlock.find(@block_content.block_id)
      @block_contents = BlockContent.where(:block_id => params[:block_id])
      render json:{page_block_id:@page_block.id}
      # render partial: "page_blocks/templates/#{@page_block.block_type}"
    else
      render :partial => 'block_contents/edit_pic'
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

  #上传图片
  def upload_image
    file=params[:edu_video].nil? ? params[:image] : params[:edu_video][:image]
    tmpfile = getFileName(file.original_filename.to_s)
    uuid = upload_video_img_bucket(file)
    url = "http://dev-mimas.oss-cn-beijing.aliyuncs.com/" << uuid
    if true
      render :json => {flag: true, url: url}
    else
      render :json => {flag: false, url: ''}
    end
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
    para[:block_type] = params[:type]

    @block_content=BlockContent.new(para)
    @page_block = PageBlock.find(params[:block_id])
    @block_contents = BlockContent.where(:block_id => params[:block_id])
    if @block_content.save
      render json:{page_block_id:@page_block.id}
      # render partial: "page_blocks/templates/#{@page_block.block_type}"
    else
      render :partial => 'block_contents/save_pic'
    end
  end
  #保存医生
  def save_doctors
    @page_block = PageBlock.find(params[:block_id])
    if @page_block.block_contents.nil? || @page_block.block_contents.empty?
      @block_content=BlockContent.new()
      @block_content.content = params[:content]
      @block_content.block_id = params[:block_id]
      @block_content.save
    else
      @block_content = @page_block.block_contents.first
      if @block_content.content.nil? || @block_content.content == ''
        content = params[:content]
      else
        content = @block_content.content << ",#{params[:content]}"
      end
      sql = ActiveRecord::Base.connection()
      sql.update "update block_contents set content = '#{content}' where id = #{@block_content.id}"
    end
    if !@block_content.content.nil? && @block_content.content != ''
      @doctors = Doctor.where("id in (#{@block_content.content})")
      @doctor = @doctors[0]
    end
    render partial: "page_blocks/templates/#{@page_block.block_type}"
  end
  #删除医生
  def delete_doctor
    doctor_id = params[:id]
    block_id = params[:block_id]
    @page_block = PageBlock.find(block_id)
    if !@page_block.nil?
      if !@page_block.block_contents.nil? && !@page_block.block_contents.empty?
        @block_content = @page_block.block_contents.first
        if !@block_content.nil?
          if !@block_content.content.nil? && @block_content.content != ''
            if @block_content.content.include?(',')
              content = @block_content.content.split(',')
              content.delete(doctor_id)
              content = content.join(",")
            else
              content = ''
            end

            sql = ActiveRecord::Base.connection()
            sql.update "update block_contents set content = '#{content}' where id = #{@block_content.id}"
          end
        end
      end
    end
    if !content.nil? && content != ''
      @doctors = Doctor.where("id in (#{content})")
      @doctor = @doctors[0]
    end
    render partial: "page_blocks/templates/#{@page_block.block_type}"
  end

  #def save_doctors
  #  para={}
  #  para[:content]=params[:content].to_s.gsub('[', '').gsub(']', '')
  #  para[:block_id]=params[:block_id]
  #  @block_content=BlockContent.new(para)
  #  @page_block = PageBlock.find(params[:block_id])
  #  if @block_content.save
  #    @doctors = Doctor.where("id in (#{@block_content.content})")
  #    @doctor = @doctors[0]
  #    render partial: "page_blocks/templates/#{@page_block.block_type}"
  #  else
  #    render :partial => 'block_contents/save_pic'
  #  end
  #end


  # DELETE /block_contents/1
  # DELETE /block_contents/1.json
  def destroy
    block_id = @block_content.block_id
    if @block_content.destroy
      if @block_content.block_type == 'hospital_environment' || @block_content.block_type == 'slides'
        if !@block_content.url.nil? && @block_content.url != ''
          delte_file_from_aliyun(@block_content.url[@block_content.url.rindex('/')+1, @block_content.url.length])
        end
      end
      render :json => {:success => true, :block_id => block_id}
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
