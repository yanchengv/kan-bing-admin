class PageBlocksController < ApplicationController
  before_action :set_page_block, only: [:show, :edit, :update, :destroy]
  skip_before_filter :verify_authenticity_token ,:update_position
  def index
    all_menus
    render :template => 'page_blocks/page_blocks_manage'
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
    count = PageBlock.where(sql).order('created_at desc').count
    totalpages = count % params[:rows].to_i == 0 ? count / params[:rows].to_i : count / params[:rows].to_i + 1
    if params[:page].to_i > totalpages
      params[:page] = 1
    end
    @page_blocks = PageBlock.where(sql).order('created_at desc').limit(params[:rows].to_i).offset(params[:rows].to_i*(params[:page].to_i-1))
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
     block_type=params[:type]
     block_name=params[:name]
     @page_block=PageBlock.new
     data=@page_block.get_template  block_type,block_name,current_user
     @page_block=data[:page_block]
     render partial: "block_contents/#{block_type}_manage"
  end



  def add_content_template
    page_block_id=params[:page_block_id]
    @page_block=PageBlock.where(id:page_block_id).first
    block_type=@page_block.block_type #block_type必须是模版的名称
    @block_contents = nil
    @block_contents=BlockContent.where(block_id:page_block_id)
    @page_block.add_content_template  page_block_id
    render :partial => "block_contents/#{@page_block.block_type}_manage", :object => @page_block
  end

  def get_doctor_list
    if params[:page_block_id]
      @page_block = PageBlock.find(params[:page_block_id])
    end
    @provinces = Province.select(:id, :name).all
    @cities = City.select(:id, :name).all
    @hospitals = Hospital.select(:id, :name).all
    @departments = Department.select(:id, :name).all
    render :partial => 'block_contents/docs_list'
  end
#获取用户所管理的非在首界面的医生列表中显示的医生
  def get_doctor_not_in_content
      sql = 'true'
      if !current_user.nil?
        if current_user.admin_type == '医院管理员'
          if !current_user.hospital_id.nil? && !current_user.hospital_id != ''
            sql << " and hospital_id = #{current_user.hospital_id}"
          end
        elsif current_user.admin_type == '科室管理员'
          if !current_user.department_id.nil? && !current_user.department_id != ''
            sql << " and department_id = #{current_user.department_id}"
          end
        end
      end
      if params[:province_id] && params[:province_id] != '' && params[:province_id] != 'all' && params[:province_id] != 'null'
        sql << " and province_id = #{params[:province_id]}"
      end
      if params[:city_id] && params[:city_id] != '' && params[:city_id] != 'all' && params[:city_id] != 'null'
        sql << " and city_id = #{params[:city_id]}"
      end
      if params[:hospital_id] && params[:hospital_id] != '' && params[:hospital_id] != 'all' && params[:hospital_id] != 'null'
        sql << " and hospital_id = #{params[:hospital_id]}"
      end
      if params[:department_id] && params[:department_id] != '' && params[:department_id] != 'all' && params[:department_id] != 'null'
        sql << " and department_id = #{params[:department_id]}"
      end
      if params[:name] && params[:name] != '' && params[:name] != 'null'
        sql << " and name like '%#{params[:name]}%' "
      end
      content = params[:content]
      if !content.nil? && content != ''
        sql << " and id not in (#{content})"
      end
      count =Doctor.where(sql).count
      totalpages = count % params[:rows].to_i == 0 ? count / params[:rows].to_i : count / params[:rows].to_i + 1
      @doctors = Doctor.where(sql).limit(params[:rows].to_i).offset(params[:rows].to_i*(params[:page].to_i-1))
      render :json => {:doctors => @doctors.as_json, :totalpages => totalpages, :currpage => params[:page].to_i, :totalrecords => count}
  end


  # GET /page_blocks/1
  # GET /page_blocks/1.json
  def show
   render :partial => 'page_blocks/show'
  end

  # GET /page_blocks/new
  def new
    all_menus
    @page_block = PageBlock.new
    render 'page_blocks/new'
  end

  # GET /page_blocks/1/edit
  def edit
     @page_block
      if @page_block.block_type == 'login'
        render :partial => 'page_blocks/show'
      else
        render :partial => "block_contents/#{@page_block.block_type}_manage"
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
    page_block_id=params[:id]
    if current_user
      @page_block.updated_id = current_user.id
      @page_block.updated_name = current_user.name

    end
    if @page_block.update(page_block_params)
      @page_block.add_content_template  page_block_id
      render :partial => "block_contents/#{@page_block.block_type}_manage", :object => @page_block

    else
      render :json => {:success => false, :errors => '修改失败！'}
    end
  end

  # 展现界面排版的页面
  def page_blocks_setting
    all_menus
    hospital_id=current_user.hospital_id
    department_id=current_user.department_id
    @page_block=PageBlock.where('hospital_id=? AND department_id=? AND is_show=?', hospital_id, department_id, true).order(position: :asc)
    @hospital_id=hospital_id
    @department_id=department_id
    render template:  'page_blocks/page_blocks_setting'
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

