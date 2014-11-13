class PageBlocksController < ApplicationController
  before_action :set_page_block, only: [:show, :edit, :update, :destroy]

  # GET /page_blocks
  # GET /page_blocks.json
  def index
    render :partial => 'page_blocks/page_blocks_manage'
  end

  def show_index
    sql = 'true'
    @page_blocks = HomePage.where(sql)
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
  end

  # GET /page_blocks/new
  def new
    @page_block = PageBlock.new
  end

  # GET /page_blocks/1/edit
  def edit
  end

  # POST /page_blocks
  # POST /page_blocks.json
  def create
    respond_to do |format|
      if @page_block.save
        format.html { redirect_to @page_block, notice: 'PageBlock was successfully created.' }
        format.json { render :show, status: :created, location: @page_block }
      else
        format.html { render :new }
        format.json { render json: @page_block.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /page_blocks/1
  # PATCH/PUT /page_blocks/1.json
  def update
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

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_page_block
    @page_block = PageBlock.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def page_block_params
    params.permit(:id, :name, :content, :created_id, :created_name, :updated_id, :updated_name, :hospital_id, :hospital_name, :department_id, :department_name, :page_id)
  end
end

