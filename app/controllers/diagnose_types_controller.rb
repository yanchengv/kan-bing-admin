class DiagnoseTypesController < ApplicationController
  before_filter :signed_in_user
  before_action :set_diagnose_type, only: [:show, :edit, :update, :destroy]

  def show_index
    @diagnose_types = DiagnoseType.all
    count = @diagnose_types.count
    totalpages = count % params[:rows].to_i == 0 ? count / params[:rows].to_i : count / params[:rows].to_i + 1
    if params[:page].to_i > totalpages
      params[:page] = 1
    end
    @diagnose_types = @diagnose_types.limit(params[:rows].to_i).offset(params[:rows].to_i*(params[:page].to_i-1))
    render :json => {:diagnose_types => @diagnose_types.as_json, :totalpages => totalpages, :currpage => params[:page].to_i, :totalrecords => count}
  end

  def oper_action
    if params[:oper] == 'add'
      create
    elsif params[:oper] == 'del'
      set_diagnose_type
      destroy
    elsif params[:oper] == 'edit'
      set_diagnose_type
      update
    end
  end

  # GET /diagnose_types/1
  # GET /diagnose_types/1.json
  def show
  end

  # GET /diagnose_types/new
  def new
    @diagnose_type = DiagnoseType.new
  end

  # GET /diagnose_types/1/edit
  def edit
  end

  # POST /diagnose_types
  # POST /diagnose_types.json
  def create
    @diagnose_type = DiagnoseType.new(diagnose_type_params)
    if @diagnose_type.save
      render :json => {:success => true}
    else
      render :json=> {:success => false, :errors => '添加失败！'}
    end

    #respond_to do |format|
    #  if @diagnose_type.save
    #    format.html { redirect_to @diagnose_type, notice: 'Admin was successfully created.' }
    #    format.json { render :show, status: :created, location: @diagnose_type }
    #  else
    #    format.html { render :new }
    #    format.json { render json: @diagnose_type.errors, status: :unprocessable_entity }
    #  end
    #end
  end

  # PATCH/PUT /diagnose_types/1
  # PATCH/PUT /diagnose_types/1.json
  def update
    if @diagnose_type.update(diagnose_type_params)
      render :json => {:success => true}
    else
      render :json => {:success => false, :errors => '修改失败！'}
    end
    #respond_to do |format|
    #  if @diagnose_type.update(diagnose_type_params)
    #    format.html { redirect_to @diagnose_type, notice: 'Admin was successfully updated.' }
    #    format.json { render :show, status: :ok, location: @diagnose_type }
    #  else
    #    format.html { render :edit }
    #    format.json { render json: @diagnose_type.errors, status: :unprocessable_entity }
    #  end
    #end
  end

  # DELETE /diagnose_types/1
  # DELETE /diagnose_types/1.json
  def destroy
   if @diagnose_type.destroy
     render :json => {:success => true}
   end
    #respond_to do |format|
    #  format.html { redirect_to diagnose_types_url, notice: 'Admin was successfully destroyed.' }
    #  format.json { head :no_content }
    #end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_diagnose_type
      @diagnose_type = DiagnoseType.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def diagnose_type_params
      params.permit(:id, :type_name)
    end
end
