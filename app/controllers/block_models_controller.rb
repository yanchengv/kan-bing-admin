class BlockModelsController < ApplicationController
  before_filter :signed_in_user
  before_action :set_block_model, only: [:show, :edit, :update, :destroy]

  # GET /block_models
  # GET /block_models.json
  def index
    render :partial => 'block_models/block_models_manage'
  end

  def show_index
    sql = 'true'
    if params[:version_num] && params[:version_num] != '' && params[:version_num] != 'null'
      sql << " and version_num like '%#{params[:version_num]}%'"
    end
    @block_models = BlockModel.where(sql)
    count = @block_models.count
    totalpages = count % params[:rows].to_i == 0 ? count / params[:rows].to_i : count / params[:rows].to_i + 1
    @block_models = @block_models.limit(params[:rows].to_i).offset(params[:rows].to_i*(params[:page].to_i-1))
    render :json => {:block_models => @block_models.as_json, :totalpages => totalpages, :currpage => params[:page].to_i, :totalrecords => count}
  end

  def oper_action
    if params[:oper] == 'add'
      create
    elsif params[:oper] == 'del'
      set_block_model
      destroy
    elsif params[:oper] == 'edit'
      set_block_model
      update
    end
  end

  # GET /block_models/1
  # GET /block_models/1.json
  def show
  end

  # GET /block_models/new
  def new
    @block_model = BlockModel.new
  end

  # GET /block_models/1/edit
  def edit
  end

  # POST /block_models
  # POST /block_models.json
  def create
    @block_model = BlockModel.new(block_model_params)
    if @block_model.save
      render :json => {:success => true}
    else
      render :json=> {:success => false, :errors => '添加失败！'}
    end

    #respond_to do |format|
    #  if @block_model.save
    #    format.html { redirect_to @block_model, notice: 'Admin was successfully created.' }
    #    format.json { render :show, status: :created, location: @block_model }
    #  else
    #    format.html { render :new }
    #    format.json { render json: @block_model.errors, status: :unprocessable_entity }
    #  end
    #end
  end

  # PATCH/PUT /block_models/1
  # PATCH/PUT /block_models/1.json
  def update
    if @block_model.update(block_model_params)
      render :json => {:success => true}
    else
      render :json => {:success => false, :errors => '修改失败！'}
    end
    #respond_to do |format|
    #  if @block_model.update(block_model_params)
    #    format.html { redirect_to @block_model, notice: 'Admin was successfully updated.' }
    #    format.json { render :show, status: :ok, location: @block_model }
    #  else
    #    format.html { render :edit }
    #    format.json { render json: @block_model.errors, status: :unprocessable_entity }
    #  end
    #end
  end

  # DELETE /block_models/1
  # DELETE /block_models/1.json
  def destroy
   if @block_model.destroy
     render :json => {:success => true}
   end
    #respond_to do |format|
    #  format.html { redirect_to block_models_url, notice: 'Admin was successfully destroyed.' }
    #  format.json { head :no_content }
    #end
  end

  def batch_delete
    if params[:ids]
      @block_models = BlockModel.where("id in #{params[:ids].join(',')}")
      if @block_models.delete_all
        render :json => {:success => true}
      end
    end
  end

  def setting
    render template: 'block_models/setting'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_block_model
      @block_model = BlockModel.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def block_model_params
      params.permit(:title, :content, :desc, :example)
    end
end
