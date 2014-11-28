class BlockContentsController < ApplicationController
  before_filter :signed_in_user
  before_action :set_block_content, only: [:show, :edit, :update, :destroy]

  # GET /block_contents
  # GET /block_contents.json
  def index
    render :partial => 'block_contents/block_contents_manage'
  end

  def show_index
    sql = 'true'
    if params[:version_num] && params[:version_num] != '' && params[:version_num] != 'null'
      sql << " and version_num like '%#{params[:version_num]}%'"
    end
    @block_contents = BlockContent.where(sql)
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
      render :json=> {:success => false, :errors => '添加失败！'}
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
      params.permit(:title, :content, :desc, :example)
    end
end
