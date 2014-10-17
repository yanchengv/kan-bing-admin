class NationalInformationsController < ApplicationController
  before_action :set_national_information, only: [:show, :edit, :update, :destroy]

  # GET /national_informations
  # GET /national_informations.json
  def index
  end

  def show_index
    sql = 'true'
    @national_informations = NationalInformation.where(sql)
    count = @national_informations.count
    totalpages = count % params[:rows].to_i == 0 ? count / params[:rows].to_i : count / params[:rows].to_i + 1
    @national_informations = @national_informations.limit(params[:rows].to_i).offset(params[:rows].to_i*(params[:page].to_i-1))
    render :json => {:national_informations => @national_informations.as_json, :totalpages => totalpages, :currpage => params[:page].to_i, :totalrecords => count}
  end

  def oper_action
    if params[:oper] == 'add'
      create
    elsif params[:oper] == 'del'
      set_national_information
      destroy
    elsif params[:oper] == 'edit'
      set_national_information
      update
    end
  end

  # GET /national_informations/1
  # GET /national_informations/1.json
  def show
  end

  # GET /national_informations/new
  def new
    @national_information = NationalInformation.new
  end

  # GET /national_informations/1/edit
  def edit
  end

  # POST /national_informations
  # POST /national_informations.json
  def create
    @national_information = NationalInformation.new(national_information_params)
    if @national_information.save
      render :json => {:success => true}
    else
      render :json=> {:success => false, :errors => '添加失败！'}
    end

    #respond_to do |format|
    #  if @national_information.save
    #    format.html { redirect_to @national_information, notice: 'Admin was successfully created.' }
    #    format.json { render :show, status: :created, location: @national_information }
    #  else
    #    format.html { render :new }
    #    format.json { render json: @national_information.errors, status: :unprocessable_entity }
    #  end
    #end
  end

  # PATCH/PUT /national_informations/1
  # PATCH/PUT /national_informations/1.json
  def update
    if @national_information.update(national_information_params)
      render :json => {:success => true}
    else
      render :json => {:success => false, :errors => '修改失败！'}
    end
    #respond_to do |format|
    #  if @national_information.update(national_information_params)
    #    format.html { redirect_to @national_information, notice: 'Admin was successfully updated.' }
    #    format.json { render :show, status: :ok, location: @national_information }
    #  else
    #    format.html { render :edit }
    #    format.json { render json: @national_information.errors, status: :unprocessable_entity }
    #  end
    #end
  end

  # DELETE /national_informations/1
  # DELETE /national_informations/1.json
  def destroy
   if @national_information.destroy
     render :json => {:success => true}
   end
    #respond_to do |format|
    #  format.html { redirect_to national_informations_url, notice: 'Admin was successfully destroyed.' }
    #  format.json { head :no_content }
    #end
  end


  def setting
    render template: 'national_informations/setting'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_national_information
      @national_information = NationalInformation.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def national_information_params
      params.permit(:id,:parent_id, :name)
    end
end
