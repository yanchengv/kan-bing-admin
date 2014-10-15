#encoding:utf-8
class TreatmentRelationshipsController < ApplicationController
    before_action :set_treatment_relationship, only: [:show, :edit, :update, :destroy]

    # GET /treatment_relationships
    # GET /treatment_relationships.json
    def index
      @hospitals = Hospital.all
      @departments = Department.all
    end

    def show_index
      sql = 'true'
      if !params[:hospital_id].nil? && params[:hospital_id] != '0' && params[:hospital_id] != 'null'
        sql << " and hospital_id = #{params[:hospital_id]}"
      end
      if !params[:department_id].nil? && params[:department_id] != '0' && params[:department_id] != 'null'
        sql << " and department_id = #{params[:department_id]}"
      end
      if !params[:name].nil? && params[:name] != '' && params[:name] != 'null'
        sql << " and (name like '%#{params[:name]}%' or spell_code like '%#{params[:name]}%')"
      end
      if params[:str] == 'false'
        sql << " and id not in (select doctor_id from treatment_relationships)"
      else
        sql << " and id in (select doctor_id from treatment_relationships)"
      end
      @doctors = Doctor.where(sql)
      count = @doctors.count
      totalpages = count % params[:rows].to_i == 0 ? count / params[:rows].to_i : count / params[:rows].to_i + 1
      @doctors = @doctors.limit(params[:rows].to_i).offset(params[:rows].to_i*(params[:page].to_i-1))
      render :json => {:doctors => @doctors.as_json(:include => [{:hospital => {:only => [:id, :name]}},{:department => {:only => [:id, :name]}}]), :totalpages => totalpages, :currpage => params[:page].to_i, :totalrecords => count}
    end

    #获取患友信息
    def get_patients
      if params[:doctor_id]
        @treatment_relationships = TreatmentRelationship.where(:doctor_id => params[:doctor_id])
        count = @treatment_relationships.count
        totalpages = count % params[:rows].to_i == 0 ? count / params[:rows].to_i : count / params[:rows].to_i + 1
        @treatment_relationships = @treatment_relationships.limit(params[:rows].to_i).offset(params[:rows].to_i*(params[:page].to_i-1))
        render :json => {:treatment_relationships => @treatment_relationships.as_json(:include => [{:doctor => {:only => [:id, :name]}},{:patient => {:only => [:id, :name, :gender, :hospital_name, :department_name]}}]), :totalpages => totalpages, :currpage => params[:page].to_i, :totalrecords => count}
      end
    end

    #获取非医患关系的患者
    def get_n_patients
      if params[:doctor_id]
        @patients = Patient.where(" id not in (select patient_id from treatment_relationships where doctor_id = ?)", params[:doctor_id])
      else
        @patients = Patient.all
      end
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

    #科室
    def get_departments
      if params[:hospital_id] && params[:hospital_id] != ''
        @departments = Department.where(:hospital_id => params[:hospital_id])
      else
        @departments = City.all
      end
      departments = {}
      @departments.each do |dept|
        departments[dept.id] = dept.name
      end
      render :json => {:departments => departments.as_json}
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
        @treatment_relationships = TreatmentRelationship.where("id in #{params[:ids].to_s.gsub('[', '(').gsub(']', ')')}")
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
