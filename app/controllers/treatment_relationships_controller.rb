#encoding:utf-8
class TreatmentRelationshipsController < ApplicationController
  before_filter :signed_in_user
    before_action :set_treatment_relationship, only: [:show, :edit, :update, :destroy]

    # GET /treatment_relationships
    # GET /treatment_relationships.json
    def index
      all_menus
      render template:  'treatment_relationships/patient_friendship'
    end

    def show_index
      sql1 = 'true'
      #查看关系是查看所有网站的用户关系
      #if current_user.admin_type == '医院管理员'
      #  if !current_user.hospital_id.nil? && !current_user.hospital_id != ''
      #    sql1 << " and hospital_id = #{current_user.hospital_id}"
      #  else
      #    sql1 << " and hospital_id = 0"
      #  end
      #elsif current_user.admin_type == '科室管理员'
      #  if !current_user.department_id.nil? && !current_user.department_id != ''
      #    sql1 << " and department_id = #{current_user.department_id}"
      #  else
      #    sql1 << " and department_id = 0"
      #  end
      #elsif current_user.admin_type == '机构管理员'
      #  if !current_user.organization_id.nil? && !current_user.organization_id != ''
      #    sql1 << " and organization_id = #{current_user.organization_id}"
      #  else
      #    sql1 << " and organization_id = 0"
      #  end
      #else
      #end
      sql = 'true'
      #hos_id = current_user.hospital_id
      #dep_id = current_user.department_id
      #if !hos_id.nil? && hos_id != ''
      #  if !dep_id.nil? && dep_id != ''
      #    sql << " and d_hospital_id=#{hos_id} and d_department_id=#{dep_id}"
      #  else
      #    sql << " and d_hospital_id=#{hos_id}"
      #  end
      #end
      if !params[:patient_name].nil? && params[:patient_name] != '' && params[:patient_name] != 'null'
        sql << " and patient_id in (select id from patients where name = '#{params[:patient_name]}' and #{sql1})"
      else
        sql << " and patient_id in (select id from patients where #{sql1})"
      end
      if !params[:doctor_name].nil? && params[:doctor_name] != '' && params[:doctor_name] != 'null'
        sql << " and doctor_id in (select id from doctors where name = '#{params[:doctor_name]}' and #{sql1})"
      else
        sql << " and doctor_id in (select id from doctors where #{sql1})"
      end
      if !params[:doctor_id].nil? && params[:doctor_id] != '' && params[:doctor_id] != 'null'
        sql << " and doctor_id = #{params[:doctor_id]} and #{sql1}"
      end
      @treatment_relationships = TreatmentRelationship.where(sql)

      count = @treatment_relationships.count
      totalpages = count % params[:rows].to_i == 0 ? count / params[:rows].to_i : count / params[:rows].to_i + 1
      if params[:page].to_i > totalpages
        params[:page] = 1
      end
      @treatment_relationships = @treatment_relationships.limit(params[:rows].to_i).offset(params[:rows].to_i*(params[:page].to_i-1))
      render :json => {:treatment_relationships => @treatment_relationships.as_json(:include => [{:doctor => {:only => [:id, :name]}}, {:patient => {:only => [:id, :name]}}]), :totalpages => totalpages, :currpage => params[:page].to_i, :totalrecords => count}
    end

    #获取患者
    def get_patients
      if params[:str] == 'default'
        @patients = {}
        totalpages = 0
        params[:page] = 1
        count = 0
      else
        sql = 'true'
        if !current_user.nil?
          if current_user.admin_type == '医院管理员'
            if !current_user.hospital_id.nil? && !current_user.hospital_id != ''
              sql << " and hospital_id = #{current_user.hospital_id}"
            else
              sql << " and hospital_id = 0"
            end
          elsif current_user.admin_type == '科室管理员'
            if !current_user.department_id.nil? && !current_user.department_id != ''
              sql << " and department_id = #{current_user.department_id}"
            else
              sql << " and department_id = 0"
            end
          elsif current_user.admin_type == '机构管理员'
            if !current_user.organization_id.nil? && !current_user.organization_id != ''
              sql << " and organization_id = #{current_user.organization_id}"
            else
              sql << " and organization_id = 0"
            end
          else
            if params[:hospital_id] && params[:hospital_id] != '' && params[:hospital_id] != 'all' && params[:hospital_id] != 'null' && params[:hospital_id] != 'undefined'
              sql << " and hospital_id = #{params[:hospital_id]}"
            end
            if params[:department_id] && params[:department_id] != '' && params[:department_id] != 'all' && params[:department_id] != 'null' && params[:department_id] != 'undefined'
              sql << " and department_id = #{params[:department_id]}"
            end
          end
        end
        if params[:province_id] && params[:province_id] != '' && params[:province_id] != 'all' && params[:province_id] != 'null' && params[:province_id] != 'undefined'
          sql << " and province_id = #{params[:province_id]}"
        end
        if params[:city_id] && params[:city_id] != '' && params[:city_id] != 'all' && params[:city_id] != 'null' && params[:city_id] != 'undefined'
          sql << " and city_id = #{params[:city_id]}"
        end
        if params[:name] && params[:name] != '' && params[:name] != 'null' && params[:name] != 'undefined'
          sql << " and name like '%#{params[:name]}%' "
        end
        if params[:doctor_id] && params[:doctor_id] != '' && params[:doctor_id] != 'null' && params[:doctor_id] != 'undefined'
          sql << " and id not in (select patient_id from treatment_relationships where doctor_id = #{params[:doctor_id]}) and ( doctor_id != #{params[:doctor_id]} or doctor_id is null )"
        end
        count = Patient.where(sql).count
        totalpages = count % params[:rows].to_i == 0 ? count / params[:rows].to_i : count / params[:rows].to_i + 1
        if params[:page].to_i > totalpages
          params[:page] = 1
        end
        @patients = Patient.where(sql).limit(params[:rows].to_i).offset(params[:rows].to_i*(params[:page].to_i-1))
      end
      render :json => {:patients => @patients.as_json, :totalpages => totalpages, :currpage => params[:page].to_i, :totalrecords => count}
    end
  #获取主治关系
  def get_main_relations
    sql1 = 'true'
    #查看关系是查看所有网站的用户关系
    #if current_user.admin_type == '医院管理员'
    #  if !current_user.hospital_id.nil? && !current_user.hospital_id != ''
    #    sql1 << " and hospital_id = #{current_user.hospital_id}"
    #  else
    #    sql1 << " and hospital_id = 0"
    #  end
    #elsif current_user.admin_type == '科室管理员'
    #  if !current_user.department_id.nil? && !current_user.department_id != ''
    #    sql1 << " and department_id = #{current_user.department_id}"
    #  else
    #    sql1 << " and department_id = 0"
    #  end
    #elsif current_user.admin_type == '机构管理员'
    #  if !current_user.organization_id.nil? && !current_user.organization_id != ''
    #    sql1 << " and organization_id = #{current_user.organization_id}"
    #  else
    #    sql1 << " and organization_id = 0"
    #  end
    #else
    #end
    sql = 'doctor_id is not null and doctor_id != \'\' and doctor_id != 0'
    if !params[:doctor_name].nil? && params[:doctor_name] != ''
      sql << " and doctor_id in (select id from doctors where name = '#{params[:doctor_name]}' and #{sql1})"
    else
      sql << " and doctor_id in (select id from doctors where #{sql1})"
    end
    if !params[:patient_name].nil? && params[:patient_name] != ''
      sql << " and name = '#{params[:patient_name]}' and #{sql1}"
    else
      sql << " and #{sql1}"
    end
    if !params[:doctor_id].nil? && params[:doctor_id] != ''
      sql << " and doctor_id = #{params[:doctor_id]}  and #{sql1}"
    end
    @patients = Patient.where(sql)
    count = @patients.count
    totalpages = count % params[:rows].to_i == 0 ? count / params[:rows].to_i : count / params[:rows].to_i + 1
    if params[:page].to_i > totalpages
      params[:page] = 1
    end
    @patients = @patients.limit(params[:rows].to_i).offset(params[:rows].to_i*(params[:page].to_i-1))
    render :json => {:patients => @patients.as_json(:include => [{:doctor => {:only => [:id, :name]}}]), :totalpages => totalpages, :currpage => params[:page].to_i, :totalrecords => count}
  end

   #保存关系
  def save_relationship
    if params[:doctor_id] && params[:patient_ids]
      params[:patient_ids].each do |pat_id|
        @treatment_relationships = TreatmentRelationship.where(:patient_id => pat_id, :doctor_id => params[:doctor_id])
        if @treatment_relationships.empty? || @treatment_relationships.nil?
          if params[:type] == 'ordinary'
            TreatmentRelationship.create(:doctor_id => params[:doctor_id], :patient_id => pat_id)
          end
          if params[:type] == 'main'
            @patient = Patient.find(pat_id)
            @patient.update_attributes(:doctor_id => params[:doctor_id])
          end
        end
      end
      render :json => {:success => true}
    else
      render :json => {:success => false}
    end
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
      @provinces = Province.select(:id, :name).all
      render :partial => 'treatment_relationships/doctors_list'
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

  #删除主治关系
  def delete_main_associate
    if !params[:patient_id].nil? && params[:patient_id] != ''
      @patient = Patient.find(params[:patient_id])
      if @patient
        if @patient.update_attributes(:doctor_id => '')
          render :json => {:success => true}
        else
          render :json => {:success => false, :error => '关系解除失败!'}
        end
      else
        render :json => {:success => false, :error => '没有找到对应的关系!'}
      end
    else
      render :json => {:success => false, :error => '没有选择要删除的关系!'}
    end
  end
    #批量删除
    def batch_delete
      if params[:ids]
        @treatment_relationships = TreatmentRelationship.where("id in (#{params[:ids].join(',')})")
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
