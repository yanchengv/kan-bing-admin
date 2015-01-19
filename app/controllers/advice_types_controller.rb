class AdviceTypesController < ApplicationController
  before_filter :signed_in_user
  before_action :set_advice_type, only: [:show, :edit, :update, :destroy]

  def show_index
    @advice_types = AdviceType.all
    count = @advice_types.count
    totalpages = count % params[:rows].to_i == 0 ? count / params[:rows].to_i : count / params[:rows].to_i + 1
    if params[:page].to_i > totalpages
      params[:page] = 1
    end
    @advice_types = @advice_types.limit(params[:rows].to_i).offset(params[:rows].to_i*(params[:page].to_i-1))
    render :json => {:advice_types => @advice_types.as_json, :totalpages => totalpages, :currpage => params[:page].to_i, :totalrecords => count}
  end

  def oper_action
    if params[:oper] == 'add'
      create
    elsif params[:oper] == 'del'
      set_advice_type
      destroy
    elsif params[:oper] == 'edit'
      set_advice_type
      update
    end
  end

  # GET /advice_types/1
  # GET /advice_types/1.json
  def show
  end

  # GET /advice_types/new
  def new
    @advice_type = AdviceType.new
  end

  # GET /advice_types/1/edit
  def edit
  end

  # POST /advice_types
  # POST /advice_types.json
  def create
    @advice_type = AdviceType.new(advice_type_params)
    if @advice_type.save
      render :json => {:success => true}
    else
      render :json=> {:success => false, :errors => '添加失败！'}
    end

    #respond_to do |format|
    #  if @advice_type.save
    #    format.html { redirect_to @advice_type, notice: 'Admin was successfully created.' }
    #    format.json { render :show, status: :created, location: @advice_type }
    #  else
    #    format.html { render :new }
    #    format.json { render json: @advice_type.errors, status: :unprocessable_entity }
    #  end
    #end
  end

  # PATCH/PUT /advice_types/1
  # PATCH/PUT /advice_types/1.json
  def update
    if @advice_type.update(advice_type_params)
      render :json => {:success => true}
    else
      render :json => {:success => false, :errors => '修改失败！'}
    end
    #respond_to do |format|
    #  if @advice_type.update(advice_type_params)
    #    format.html { redirect_to @advice_type, notice: 'Admin was successfully updated.' }
    #    format.json { render :show, status: :ok, location: @advice_type }
    #  else
    #    format.html { render :edit }
    #    format.json { render json: @advice_type.errors, status: :unprocessable_entity }
    #  end
    #end
  end

  # DELETE /advice_types/1
  # DELETE /advice_types/1.json
  def destroy
   if @advice_type.destroy
     render :json => {:success => true}
   end
    #respond_to do |format|
    #  format.html { redirect_to advice_types_url, notice: 'Admin was successfully destroyed.' }
    #  format.json { head :no_content }
    #end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_advice_type
      @advice_type = AdviceType.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def advice_type_params
      params.permit(:id, :type_name)
    end
end
