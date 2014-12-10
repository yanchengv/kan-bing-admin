#encoding:utf-8
class TreatmentRelationshipsController < ApplicationController
  before_filter :signed_in_user
    before_action :set_treatment_relationship, only: [:show, :edit, :update, :destroy]

    # GET /treatment_relationships
    # GET /treatment_relationships.json
    def index
      render partial: 'treatment_relationships/patient_friendship'
    end

    def show_index
      sql = 'true'
      if !params[:patient_name].nil? && params[:patient_name] != '' && params[:patient_name] != 'null'
        sql << " and patient_id in (select id from patients where name = '#{params[:patient_name]}')"
      end
      if !params[:doctor_name].nil? && params[:doctor_name] != '' && params[:doctor_name] != 'null'
        sql << " and doctor_id in (select id from doctors where name = '#{params[:doctor_name]}')"
      end
      @treatment_relationships = TreatmentRelationship.where(sql)
      count = @treatment_relationships.count
      totalpages = count % params[:rows].to_i == 0 ? count / params[:rows].to_i : count / params[:rows].to_i + 1
      @treatment_relationships = @treatment_relationships.limit(params[:rows].to_i).offset(params[:rows].to_i*(params[:page].to_i-1))
      render :json => {:treatment_relationships => @treatment_relationships.as_json(:include => [{:doctor => {:only => [:id, :name]}}, {:patient => {:only => [:id, :name]}}]), :totalpages => totalpages, :currpage => params[:page].to_i, :totalrecords => count}
    end

    #获取医生
    def get_doctors
      @doctors = Doctor.all
      docs = {}
      @doctors.each do |doc|
        docs[doc.id] = doc.name
      end
      render :json => {:doctors => docs.as_json}
    end

    #获取患者
    def get_patients
      @patients = Patient.all
      pats = {}
      @patients.each do |pat|
        pats[pat.id] = pat.name
      end
      render :json => {:patients => pats.as_json}
    end

    def oper_action
      if params[:oper] == 'add'
        create
      elsif params[:oper] == 'del'
        set_treatment_relationship
        destroy
      elsif params[:oper] == 'edit'
        set_treatment_relationship
        update
      end
    end

    # GET /treatment_relationships/1
    # GET /treatment_relationships/1.json
    def show
    end

    # GET /treatment_relationships/new
    def new
      @treatment_relationship = TreatmentRelationship.new
    end

    # GET /treatment_relationships/1/edit
    def edit
    end

    # POST /treatment_relationships
    # POST /treatment_relationships.json
    def create
      @treatment_relationship = TreatmentRelationship.new(treatment_relationship_params)
      @treatment_relationships = TreatmentRelationship.where(:patient_id => @treatment_relationship.patient_id, :doctor_id => @treatment_relationship.doctor_id)
      if @treatment_relationships.empty?
        if @treatment_relationship.save
          render :json => {:success => true}
        else
          render :json => {:success => false, :errors => '添加失败！'}
        end
      else
        render :json => {:success => false, :errors => '关联关系已存在！'}
      end

      #respond_to do |format|
      #  if @treatment_relationship.save
      #    format.html { redirect_to @treatment_relationship, notice: 'Admin was successfully created.' }
      #    format.json { render :show, status: :created, location: @treatment_relationship }
      #  else
      #    format.html { render :new }
      #    format.json { render json: @treatment_relationship.errors, status: :unprocessable_entity }
      #  end
      #end
    end

    # PATCH/PUT /treatment_relationships/1
    # PATCH/PUT /treatment_relationships/1.json
    def update
      if @treatment_relationship.update(treatment_relationship_params)
        render :json => {:success => true}
      else
        render :json => {:success => false, :errors => '修改失败！'}
      end
      #respond_to do |format|
      #  if @treatment_relationship.update(treatment_relationship_params)
      #    format.html { redirect_to @treatment_relationship, notice: 'Admin was successfully updated.' }
      #    format.json { render :show, status: :ok, location: @treatment_relationship }
      #  else
      #    format.html { render :edit }
      #    format.json { render json: @treatment_relationship.errors, status: :unprocessable_entity }
      #  end
      #end
    end

    # DELETE /treatment_relationships/1
    # DELETE /treatment_relationships/1.json
    def destroy
      if @treatment_relationship.destroy
        render :json => {:success => true}
      end
      #respond_to do |format|
      #  format.html { redirect_to treatment_relationships_url, notice: 'Admin was successfully destroyed.' }
      #  format.json { head :no_content }
      #end
    end
    #批量删除
    def batch_delete
      if params[:ids]
        @treatment_relationships = TreatmentRelationship.where("id in #{params[:ids].join(',')}")
        if @treatment_relationships.delete_all
          render :json => {:success => true}
        end
      end
    end

    def setting
      render template: 'treatment_relationships/setting'
    end

    private
    # Use callbacks to share common setup or constraints between actions.
    def set_treatment_relationship
      @treatment_relationship = TreatmentRelationship.find(params[:id])
    end


    # Never trust parameters from the scary internet, only allow the white list through.
    def treatment_relationship_params
      params.permit(:id, :doctor_id, :patient_id)
    end
  end
