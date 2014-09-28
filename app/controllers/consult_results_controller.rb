class ConsultResultsController < ApplicationController
  before_action :set_consult_result, only: [:show, :edit, :update, :destroy]

  # GET /consult_results
  # GET /consult_results.json
  def index
    @consult_results = ConsultResult.all
  end

  # GET /consult_results/1
  # GET /consult_results/1.json
  def show
  end

  # GET /consult_results/new
  def new
    @consult_result = ConsultResult.new
  end

  # GET /consult_results/1/edit
  def edit
  end

  # POST /consult_results
  # POST /consult_results.json
  def create
    if current_user
      @consult_result = ConsultResult.new(consult_result_params)
      @consult_result.created_by = current_user.id
      if current_user.doctor_id
        @consult_result.respond_identity = 0 #医生
      end
      if current_user.nurse_id
        @consult_result.respond_identity = 2 #护士
      end
      if current_user.patient_id
        @consult_result.respond_identity = 1 #患者
      end

      if @consult_result.save
        if @consult_result.respond_content.include?("***")
          msg = "所填信息有敏感词，请自行更改！"
        else
          msg = ''
        end
        render json: {:success => true, :error => msg}
      else
        render json: {:success => false, :error => '信息有误，请确认！'}
      end
    else
      render json: {:success => false, :error => '用户需登录才能咨询！'}
    end
  end

  # PATCH/PUT /consult_results/1
  # PATCH/PUT /consult_results/1.json
  def update
    if current_user
      if @consult_result.update(consult_result_params)
        if @consult_result.respond_content.include?("***")
          msg = "所填信息有敏感词，请自行更改！"
        else
          msg = ''
        end
        render json: {:success => true, :error => msg}
      else
        render json: {:success => false, :error => '信息有误，请确认！'}
      end
    else
      render json: {:success => false, :error => '用户需登录才能修改咨询回复信息！'}
    end
    #respond_to do |format|
    #  if @consult_result.update(consult_result_params)
    #    format.html { redirect_to @consult_result, notice: 'ConsultResult was successfully updated.' }
    #    format.json { render :show, status: :ok, location: @consult_result }
    #  else
    #    format.html { render :edit }
    #    format.json { render json: @consult_result.errors, status: :unprocessable_entity }
    #  end
    #end
  end

  # DELETE /consult_results/1
  # DELETE /consult_results/1.json
  def destroy
    #@consult_result.destroy
    #respond_to do |format|
    #  format.html { redirect_to consult_results_url, notice: 'ConsultResult was successfully destroyed.' }
    #  format.json { head :no_content }
    #end
    if @consult_result.destroy
      render json: {:success => true, :error => '删除成功！'}
    else
      render json: {:success => true, :error => '删除失败！'}
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_consult_result
    @consult_result = ConsultResult.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def consult_result_params
    params.require(:consult_result).permit(:respond_content, :created_by, :respond_identity, :consult_id, :privilege_view)
  end
end

