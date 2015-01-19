class MedicalAdvicesController < ApplicationController
  before_filter :signed_in_user
  before_action :set_medical_advice, only: [:show, :edit, :update, :destroy]

  # GET /medical_advices
  # GET /medical_advices.json
  def index
    render :partial => 'medical_advices/medical_advices_manage'
  end

  def show_index
    sql = 'true'
    if params[:title] && params[:title] != '' && params[:title] != 'null'
      sql << " and title like '%#{params[:title]}%'"
    end
    if params[:advice_type] && params[:advice_type] != '' && params[:advice_type] != 'null'
      sql << " and advice_type = #{params[:advice_type]}"
    end
    @medical_advices = MedicalAdvice.where(sql)
    count = @medical_advices.count
    totalpages = count % params[:rows].to_i == 0 ? count / params[:rows].to_i : count / params[:rows].to_i + 1
    if params[:page].to_i > totalpages
      params[:page] = 1
    end
    @medical_advices = @medical_advices.limit(params[:rows].to_i).offset(params[:rows].to_i*(params[:page].to_i-1))
    render :json => {:medical_advices => @medical_advices.as_json, :totalpages => totalpages, :currpage => params[:page].to_i, :totalrecords => count}
  end

  def oper_action
    if params[:oper] == 'add'
      create
    elsif params[:oper] == 'del'
      set_medical_advice
      destroy
    elsif params[:oper] == 'edit'
      set_medical_advice
      update
    end
  end

  # GET /medical_advices/1
  # GET /medical_advices/1.json
  def show
  end

  # GET /medical_advices/new
  def new
    @medical_advice = MedicalAdvice.new
  end

  # GET /medical_advices/1/edit
  def edit
  end

  # POST /medical_advices
  # POST /medical_advices.json
  def create
    @medical_advice = MedicalAdvice.new(medical_advice_params)
    if current_user
      @medical_advice.created_by_id = current_user.id
      @medical_advice.created_by_name = current_user.name
    end
    if @medical_advice.save
      render :json => {:success => true}
    else
      render :json=> {:success => false, :errors => '添加失败！'}
    end

    #respond_to do |format|
    #  if @medical_advice.save
    #    format.html { redirect_to @medical_advice, notice: 'Admin was successfully created.' }
    #    format.json { render :show, status: :created, location: @medical_advice }
    #  else
    #    format.html { render :new }
    #    format.json { render json: @medical_advice.errors, status: :unprocessable_entity }
    #  end
    #end
  end

  # PATCH/PUT /medical_advices/1
  # PATCH/PUT /medical_advices/1.json
  def update
    if @medical_advice.update(medical_advice_params)
      render :json => {:success => true}
    else
      render :json => {:success => false, :errors => '修改失败！'}
    end
    #respond_to do |format|
    #  if @medical_advice.update(medical_advice_params)
    #    format.html { redirect_to @medical_advice, notice: 'Admin was successfully updated.' }
    #    format.json { render :show, status: :ok, location: @medical_advice }
    #  else
    #    format.html { render :edit }
    #    format.json { render json: @medical_advice.errors, status: :unprocessable_entity }
    #  end
    #end
  end

  # DELETE /medical_advices/1
  # DELETE /medical_advices/1.json
  def destroy
   if @medical_advice.destroy
     render :json => {:success => true}
   end
    #respond_to do |format|
    #  format.html { redirect_to medical_advices_url, notice: 'Admin was successfully destroyed.' }
    #  format.json { head :no_content }
    #end
  end

  def batch_delete
    if params[:ids]
      @medical_advices = MedicalAdvice.where("id in (#{params[:ids].join(',')})")
      if @medical_advices.delete_all
        render :json => {:success => true}
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_medical_advice
      @medical_advice = MedicalAdvice.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def medical_advice_params
      params.permit(:id, :title, :created_by_id, :created_by_name, :advice_type)
    end
end
