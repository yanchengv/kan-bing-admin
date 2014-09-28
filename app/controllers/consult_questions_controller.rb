class ConsultQuestionsController < ApplicationController
  before_action :set_consult_question, only: [:show, :edit, :update, :destroy]

  # GET /consult_questions
  # GET /consult_questions.json
  def index
    if current_user
      if params[:consult_content] && params[:consult_content] != ''
        @consult_questions = ConsultQuestion.where("consult_content like ? and consulting_by = ? or created_by = ? ", "%#{params[:consult_content]}%", current_user.id, current_user.id).order('created_at desc')
      else
        @consult_questions = ConsultQuestion.where('consulting_by = ? or created_by = ?', current_user.id, current_user.id).order('created_at desc')
      end
    else
      @consult_questions = ConsultQuestion.all.order('created_at desc')
    end
    @consult_questions = @consult_questions.paginate(:per_page => 15, :page => params[:page])
  end

  # GET /consult_questions/1
  # GET /consult_questions/1.json
  def show
  end

  # GET /consult_questions/new
  def new
    @consult_question = ConsultQuestion.new
  end

  # GET /consult_questions/1/edit
  def edit
  end

  # POST /consult_questions
  # POST /consult_questions.json
  def create
    if current_user
      @consult_question = ConsultQuestion.new(consult_question_params)
      @consult_question.created_by = current_user.id
      if current_user.doctor_id
        @consult_question.consult_identity = 0 #医生
      end
      if current_user.nurse_id
        @consult_question.consult_identity = 2 #护士
      end
      if current_user.patient_id
        @consult_question.consult_identity = 1 #患者
      end

      if @consult_question.save
        if @consult_question.consult_content.include?("***")
          msg = "所填信息有敏感词，请自行更改！"
        else
          msg = '保存成功！'
        end
          render json: {:success => true, :error => msg}
      else
        render json: {:success => true, :error => '信息有误，请确认！'}
      end
    else
      render json: {:success => false, :error => '用户需登录才能咨询！'}
    end
  end

  # PATCH/PUT /consult_questions/1
  # PATCH/PUT /consult_questions/1.json
  def update
    if @consult_question.update(consult_question_params)
      if @consult_question.consult_content.include?("***")
        msg = "所填信息有敏感词，请自行更改！"
      else
        msg = '修改成功！'
      end
      render json: {:success => true, :error => msg}
    else
      render json: {:success => true, :error => '信息有误，请确认！'}
    end
=begin
    respond_to do |format|
      if @consult_question.update(consult_question_params)
        format.html { redirect_to @consult_question, notice: 'ConsultQuestion was successfully updated.' }
        format.json { render :show, status: :ok, location: @consult_question }
      else
        format.html { render :edit }
        format.json { render json: @consult_question.errors, status: :unprocessable_entity }
      end
    end
=end
  end

  # DELETE /consult_questions/1
  # DELETE /consult_questions/1.json
  def destroy
    #respond_to do |format|
    #  format.html { redirect_to consult_questions_url, notice: 'ConsultQuestion was successfully destroyed.' }
    #  format.json { head :no_content }
    #end
    if @consult_question.destroy
      render json: {:success => true, :error => '删除成功！'}
    else
      render json: {:success => true, :error => '删除失败！'}
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_consult_question
    @consult_question = ConsultQuestion.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def consult_question_params
    params.require(:consult_question).permit(:consult_content, :consulting_by, :created_by, :consult_identity, :privilege_view)
  end
end

