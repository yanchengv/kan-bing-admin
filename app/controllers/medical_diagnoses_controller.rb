class MedicalDiagnosesController < ApplicationController
  before_filter :signed_in_user
  before_action :set_medical_diagnose, only: [:show, :edit, :update, :destroy]

  # GET /medical_diagnoses
  # GET /medical_diagnoses.json
  def index
    @diagnose_types = DiagnoseType.all
    render :partial => 'medical_diagnoses/medical_diagnoses_manage'
  end

  def show_index
    sql = 'true'
    if params[:title] && params[:title] != '' && params[:title] != 'null'
      sql << " and title like '%#{params[:title]}%'"
    end
    if params[:diagnose_type_id] && params[:diagnose_type_id] != '' && params[:diagnose_type_id] != 'null'
      sql << " and diagnose_type_id = #{params[:diagnose_type_id]}"
    end
    @medical_diagnoses = MedicalDiagnose.where(sql)
    count = @medical_diagnoses.count
    totalpages = count % params[:rows].to_i == 0 ? count / params[:rows].to_i : count / params[:rows].to_i + 1
    if params[:page].to_i > totalpages
      params[:page] = 1
    end
    @medical_diagnoses = @medical_diagnoses.limit(params[:rows].to_i).offset(params[:rows].to_i*(params[:page].to_i-1))
    render :json => {:medical_diagnoses => @medical_diagnoses.as_json(:include => [{:diagnose_type => {:only => [:id, :type_name]}}]), :totalpages => totalpages, :currpage => params[:page].to_i, :totalrecords => count}
  end

  def get_diagnose_types
    @diagnose_types = DiagnoseType.all
    diagnose_types = {}
    @diagnose_types.each do |type|
      diagnose_types[type.id] = type.type_name
    end
    render :json => {:diagnose_types => diagnose_types.as_json}
  end

  def oper_action
    if params[:oper] == 'add'
      create
    elsif params[:oper] == 'del'
      set_medical_diagnose
      destroy
    elsif params[:oper] == 'edit'
      set_medical_diagnose
      update
    end
  end

  # GET /medical_diagnoses/1
  # GET /medical_diagnoses/1.json
  def show
  end

  # GET /medical_diagnoses/new
  def new
    @medical_diagnose = MedicalDiagnose.new
  end

  # GET /medical_diagnoses/1/edit
  def edit
  end

  # POST /medical_diagnoses
  # POST /medical_diagnoses.json
  def create
    @medical_diagnose = MedicalDiagnose.new(medical_diagnose_params)
    if current_user
      @medical_diagnose.created_by_id = current_user.id
      @medical_diagnose.created_by_name = current_user.name
    end
    if @medical_diagnose.save
      render :json => {:success => true}
    else
      render :json=> {:success => false, :errors => '添加失败！'}
    end

    #respond_to do |format|
    #  if @medical_diagnose.save
    #    format.html { redirect_to @medical_diagnose, notice: 'Admin was successfully created.' }
    #    format.json { render :show, status: :created, location: @medical_diagnose }
    #  else
    #    format.html { render :new }
    #    format.json { render json: @medical_diagnose.errors, status: :unprocessable_entity }
    #  end
    #end
  end

  # PATCH/PUT /medical_diagnoses/1
  # PATCH/PUT /medical_diagnoses/1.json
  def update
    if @medical_diagnose.update(medical_diagnose_params)
      render :json => {:success => true}
    else
      render :json => {:success => false, :errors => '修改失败！'}
    end
    #respond_to do |format|
    #  if @medical_diagnose.update(medical_diagnose_params)
    #    format.html { redirect_to @medical_diagnose, notice: 'Admin was successfully updated.' }
    #    format.json { render :show, status: :ok, location: @medical_diagnose }
    #  else
    #    format.html { render :edit }
    #    format.json { render json: @medical_diagnose.errors, status: :unprocessable_entity }
    #  end
    #end
  end

  # DELETE /medical_diagnoses/1
  # DELETE /medical_diagnoses/1.json
  def destroy
   if @medical_diagnose.destroy
     render :json => {:success => true}
   end
    #respond_to do |format|
    #  format.html { redirect_to medical_diagnoses_url, notice: 'Admin was successfully destroyed.' }
    #  format.json { head :no_content }
    #end
  end

  def batch_delete
    if params[:ids]
      @medical_diagnoses = MedicalDiagnose.where("id in (#{params[:ids].join(',')})")
      if @medical_diagnoses.delete_all
        render :json => {:success => true}
      end
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_medical_diagnose
      @medical_diagnose = MedicalDiagnose.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def medical_diagnose_params
      params.permit(:id, :title,:created_by_id,  :created_by_name, :diagnose_type_id)
    end
end
