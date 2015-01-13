class ConsultAccusesController < ApplicationController
  before_filter :signed_in_user
  before_action :set_consult_accuse, only: [:show, :edit, :update, :destroy]

  # GET /consult_accuses
  # GET /consult_accuses.json
  def index
    render :partial => 'consult_accuses/consult_accuess_manage'
  end
#被举报的咨询
  def index_accuses
    #@consult_accuses = ConsultAccuse.all
    sql = 'id in (select question_id from consult_accuses)'
    hos_id = current_user.hospital_id
    dep_id = current_user.department_id
    if !hos_id.nil? && hos_id != ''
      if !dep_id.nil? && dep_id != ''
        doc = "select id from doctors where hospital_id=#{hos_id} and department_id=#{dep_id}"
        pat = "select id from patients where hospital_id=#{hos_id} and department_id=#{dep_id}"
      else
        doc = "select id from doctors where hospital_id=#{hos_id}"
        pat = "select id from patients where hospital_id=#{hos_id}"
      end
      sql << " and created_by in (select id from users where doctor_id in ("+doc+") or patient_id in ("+pat+"))"
    end
    if !params[:content].nil? && params[:content] != ''
      sql << " and consult_content like '%#{params[:content]}%'"
    end
    @consult_questions = ConsultQuestion.where( sql )
    count = @consult_questions.count
    totalpages = count % params[:rows].to_i == 0 ? count / params[:rows].to_i : count / params[:rows].to_i + 1
    if params[:page].to_i > totalpages
      params[:page] = 1
    end
    render :json => {:consult_questions => @consult_questions.as_json,:totalpages => totalpages, :currpage => params[:page].to_i, :totalrecords => count}
  end
  #被举报的回复
  def index_results
    sql = 'id in (select result_id from consult_accuses)'
    hos_id = current_user.hospital_id
    dep_id = current_user.department_id
    if !hos_id.nil? && hos_id != ''
      if !dep_id.nil? && dep_id != ''
        doc = "select id from doctors where hospital_id=#{hos_id} and department_id=#{dep_id}"
        pat = "select id from patients where hospital_id=#{hos_id} and department_id=#{dep_id}"
      else
        doc = "select id from doctors where hospital_id=#{hos_id}"
        pat = "select id from patients where hospital_id=#{hos_id}"
      end
      sql << " and created_by in (select id from users where doctor_id in ("+doc+") or patient_id in ("+pat+"))"
    end
    if !params[:content].nil? && params[:content] != ''
      sql << " and respond_content like '%#{params[:content]}%'"
    end
   # @consult_accuses = ConsultAccuse.all
    @consult_results = ConsultResult.where(sql)
    count = @consult_results.count
    totalpages = count % params[:rows].to_i == 0 ? count / params[:rows].to_i : count / params[:rows].to_i + 1
    if params[:page].to_i > totalpages
      params[:page] = 1
    end
    render :json => {:consult_results => @consult_results.as_json,:totalpages => totalpages, :currpage => params[:page].to_i, :totalrecords => count}
  end
  #操作转向
  def oper_action
    if params[:oper] == 'del_que'
      destroy_que
    elsif params[:oper] == 'del'
      set_consult_accuse
      destroy
    elsif params[:oper] == 'del_res'
     destroy_res
    end
  end
  # GET /consult_accuses/1
  # GET /consult_accuses/1.json
  def show
  end

  # GET /consult_accuses/new
  def new
    @consult_accuse = ConsultAccuse.new
  end

  # GET /consult_accuses/1/edit
  def edit
  end
  #根据question_id查询举报信息
  def get_accuses
    if !params[:question_id].nil? && params[:question_id] != ''
      @question = ConsultQuestion.find(params[:question_id])
      @consult_accuses = @question.consult_accuses
    end
    if !params[:result_id].nil? && params[:result_id] != ''
      @result = ConsultResult.find(params[:result_id])
      @consult_accuses = @result.consult_accuses
    end
    count = @consult_accuses.count
    totalpages = count % params[:rows].to_i == 0 ? count / params[:rows].to_i : count / params[:rows].to_i + 1
    render :json => {:consult_accuses => @consult_accuses.as_json,:totalpages => totalpages, :currpage => params[:page].to_i, :totalrecords => count}
  end

  # POST /consult_accuses
  # POST /consult_accuses.json
  def create
    respond_to do |format|
      if @consult_accuse.save
        format.html { redirect_to @consult_accuse, notice: 'ConsultAccuse was successfully created.' }
        format.json { render :show, status: :created, location: @consult_accuse }
      else
        format.html { render :new }
        format.json { render json: @consult_accuse.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /consult_accuses/1
  # PATCH/PUT /consult_accuses/1.json
  def update
    respond_to do |format|
      if @consult_accuse.update(consult_accuse_params)
        format.html { redirect_to @consult_accuse, notice: 'ConsultAccuse was successfully updated.' }
        format.json { render :show, status: :ok, location: @consult_accuse }
      else
        format.html { render :edit }
        format.json { render json: @consult_accuse.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /consult_accuses/1
  # DELETE /consult_accuses/1.json
  def destroy
    if @consult_accuse.destroy
      render :json => {:success => true}
    end
    #@consult_accuse.destroy
    #respond_to do |format|
    #  format.html { redirect_to consult_accuses_url, notice: 'ConsultAccuse was successfully destroyed.' }
    #  format.json { head :no_content }
    #end
  end

  def destroy_que
    if !params[:id].nil? && params[:id] != ''
      @questions = ConsultQuestion.where(:id => params[:id])
      @questions.each do |question|
        if question
          question.consult_results.each do |result|
            result.consult_accuses.delete_all
          end
          question.consult_results.delete_all
        end
      end
      if ConsultQuestion.find(params[:id]).destroy
        #@accuses = ConsultAccuse.where(question_id: params[:id])
        #@accuses.delete_all
        render :json => {:success => true}
      else
        render :json => {:success => false, :error => '删除失败！'}
      end
    else
      render :json => {:success => false, :error => '请选择删除对象！'}
    end
  end

  def destroy_res
    if !params[:id].nil? && params[:id] != ''
      @results = ConsultResult.where(:id => params[:id])
      @results.each do |result|
        if result
          result.consult_accuses.delete_all
        end
      end
      if ConsultResult.find(params[:id]).destroy
        #ConsultAccuse.where(result_id: params[:id]).delete_all
        render :json => {:success => true}
      else
        render :json => {:success => false, :error => '删除失败！'}
      end
    else
      render :json => {:success => false, :error => '请选择删除对象！'}
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_consult_accuse
    @consult_accuse = ConsultAccuse.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def consult_accuse_params
    params.permit(:reason, :created_by, :question_id, :result_id)
  end
end

