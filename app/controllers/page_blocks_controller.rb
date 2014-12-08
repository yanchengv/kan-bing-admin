class PageBlocksController < ApplicationController
  before_action :set_page_block, only: [:show, :edit, :update, :destroy]
  skip_before_filter :verify_authenticity_token ,:update_position
  # GET /page_blocks
  # GET /page_blocks.json
  def index
    render :partial => 'page_blocks/page_blocks_manage'
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

  # 获取模版
  def get_template
     block_name=params[:type]
    render partial: "page_blocks/templates/#{block_name}"
  end

  def add_content_template
    page_block_id=params[:page_block_id]
    @page_block=PageBlock.where(id:page_block_id).first
    block_type=@page_block.block_type #block_type必须是模版的名称
    @block_contents=BlockContent.where(block_id:page_block_id)
    render partial: "page_blocks/templates/#{block_type}"
  end


  def update_template
    page_block_id=params[:page_block_id]
    content = params[:content]
    page_block=PageBlock.where(id:page_block_id).first
    page_block.update_attributes(content:content)
    # sql = ActiveRecord::Base.connection()
    # sql.update "update page_blocks set content = '#{content}' where id = #{page_block.id}"
   #@page_block.update_attributes(content:content)
    @page_block=PageBlock.find(page_block_id)
    @block_contents = @page_block.block_contents
    #render :partial => 'block_contents/block_contents_manage'
    if @page_block.block_type == 'login'
      render :partial => 'page_blocks/show'
    elsif @page_block.block_type == 'doctor_list'
      @ids = @block_contents.first.content
      render :partial => 'block_contents/block_doctors_manage'
    elsif @page_block.block_type == 'anlizongshu' || @page_block.block_type == 'jianjie'
      render :partial => 'block_contents/block_contents_manage'
    elsif @page_block.block_type == 'hospital_environment' || @page_block.block_type == 'slides'
      render :partial => 'block_contents/picture_list_manage', :object => @page_block
    end
  end


  def save_template
    name=params[:name]
    block_type=params[:type]
    content= params[:content]
    hospital_id=current_user.hospital_id
    department_id=current_user.department_id
    @page_block=PageBlock.new(name:name,block_type:block_type,content:content,hospital_id:hospital_id,department_id:department_id)
    @page_block.save
    if block_type == 'login'
      render :partial => 'page_blocks/show'
    elsif block_type == 'doctor_list'
      render :partial => 'block_contents/block_doctors_manage'
    elsif block_type == 'anlizongshu' || block_type == 'jianjie'
      render :partial => 'block_contents/block_contents_manage'
    elsif block_type == 'hospital_environment' || block_type == 'slides'
      render :partial => 'block_contents/picture_list_manage'
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
    render :partial => 'page_blocks/new'
  end

  # GET /page_blocks/1/edit
  def edit
     @page_block
      if @page_block.block_type == 'login'
        render :partial => 'page_blocks/show'
      elsif @page_block.block_type == 'anlizongshu' || @page_block.block_type == 'jianjie'
        render :partial => 'block_contents/block_contents_manage', :object => @page_block
      elsif @page_block.block_type == 'hospital_environment' || @page_block.block_type == 'slides'
        render :partial => 'block_contents/picture_list_manage'
      elsif @page_block.block_type == 'doctor_list'
        render :partial => 'block_contents/block_doctors_manage'
      else
        render :partial => 'page_blocks/show'
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
        render :json => {:success => true}
      else
        render :json => {:success => false, :errors => '添加失败！'}
      end
  end

  # PATCH/PUT /page_blocks/1
  # PATCH/PUT /page_blocks/1.json
  def update
    if current_user
      @page_block.updated_id = current_user.id
      @page_block.updated_name = current_user.name
    end
    if @page_block.update(page_block_params)
      if @page_block.block_type == 'anlizongshu' || @page_block.block_type == 'jianjie'
        render :partial => 'block_contents/block_contents_manage', :object => @page_block

      elsif @page_block.block_type == 'hospital_environment' || @page_block.block_type == 'slides'
        render :partial => 'block_contents/picture_list_manage', :object => @page_block
      elsif @page_block.block_type == 'doctor_list'
        render :partial => 'block_contents/block_doctors_manage', :object => @page_block
      else
        render :partial => 'page_blocks/show'
      end
    else
      render :json => {:success => false, :errors => '修改失败！'}
    end
  end

  # 展现界面排版的页面
  def page_blocks_setting
    hospital_id=current_user.hospital_id
    department_id=current_user.department_id
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


  private
  # Use callbacks to share common setup or constraints between actions.
  def set_page_block
    @page_block = PageBlock.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def page_block_params
    params[:page_block].permit(:id, :name, :content, :created_id, :created_name, :updated_id, :updated_name, :hospital_id, :hospital_name, :department_id, :department_name, :page_id, :position, :is_show,:block_type)
  end
end

