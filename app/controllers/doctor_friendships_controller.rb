#encoding:utf-8
class DoctorFriendshipsController < ApplicationController
  before_filter :signed_in_user
    before_action :set_doctor_friendship, only: [:show, :edit, :update, :destroy]

    # GET /doctor_friendships
    # GET /doctor_friendships.json
    def index
      render partial: 'doctor_friendships/doctor_friendship'
    end

    def show_index
      sql = 'true'
      if !params[:name].nil? && params[:name] != '' && params[:name] != 'null'
        sql << " and doctor1_id in (select id from doctors where name = '#{params[:name]}') or doctor2_id in (select id from doctors where name = '#{params[:name]}')"
      end
      @doctor_friendships = DoctorFriendship.where(sql)
      count = @doctor_friendships.count
      totalpages = count % params[:rows].to_i == 0 ? count / params[:rows].to_i : count / params[:rows].to_i + 1
      @doctor_friendships = @doctor_friendships.limit(params[:rows].to_i).offset(params[:rows].to_i*(params[:page].to_i-1))
      render :json => {:doctor_friendships => @doctor_friendships.as_json(:include => [{:doctor1 => {:only => [:id, :name]}}, {:doctor2 => {:only => [:id, :name]}}]), :totalpages => totalpages, :currpage => params[:page].to_i, :totalrecords => count}
    end

    #获取非医友关系的医生
    def get_doctors
      sql = 'true'
      hos_id = current_user.hospital_id
      dep_id = current_user.department_id
      if !hos_id.nil? && hos_id != ''
        if !dep_id.nil? && dep_id != ''
          sql << " and hospital_id=#{hos_id} and department_id=#{dep_id}"
        else
          sql << " and hospital_id=#{hos_id}"
        end
      end
      @doctors = Doctor.select(:id, :name).where(sql)
      docs = {}
      @doctors.each do |doc|
        docs[doc.id] = doc.name
      end
      render :json => {:doctors => docs.as_json}
    end

    def oper_action
      if params[:oper] == 'add'
        create
      elsif params[:oper] == 'del'
        set_doctor_friendship
        destroy
      elsif params[:oper] == 'edit'
        set_doctor_friendship
        update
      end
    end

    # GET /doctor_friendships/1
    # GET /doctor_friendships/1.json
    def show
    end

    # GET /doctor_friendships/new
    def new
      @doctor_friendship = DoctorFriendship.new
    end

    # GET /doctor_friendships/1/edit
    def edit
    end

    # POST /doctor_friendships
    # POST /doctor_friendships.json
    def create
      @doctor_friendship = DoctorFriendship.new(doctor_friendship_params)
      @doctor_friendships = DoctorFriendship.where(:doctor1_id => @doctor_friendship.doctor1_id, :doctor2_id => @doctor_friendship.doctor2_id)
      @doctor_friendships1 = DoctorFriendship.where(:doctor1_id => @doctor_friendship.doctor2_id, :doctor2_id => @doctor_friendship.doctor1_id)
      if @doctor_friendships.empty? && @doctor_friendships1.empty?
        if @doctor_friendship.save
          render :json => {:success => true}
        else
          render :json => {:success => false, :errors => '添加失败！'}
        end
      else
        render :json => {:success => false, :errors => '关联关系已存在！'}
      end


      #respond_to do |format|
      #  if @doctor_friendship.save
      #    format.html { redirect_to @doctor_friendship, notice: 'Admin was successfully created.' }
      #    format.json { render :show, status: :created, location: @doctor_friendship }
      #  else
      #    format.html { render :new }
      #    format.json { render json: @doctor_friendship.errors, status: :unprocessable_entity }
      #  end
      #end
    end

    # PATCH/PUT /doctor_friendships/1
    # PATCH/PUT /doctor_friendships/1.json
    def update
      if @doctor_friendship.update(doctor_friendship_params)
        render :json => {:success => true}
      else
        render :json => {:success => false, :errors => '修改失败！'}
      end
      #respond_to do |format|
      #  if @doctor_friendship.update(doctor_friendship_params)
      #    format.html { redirect_to @doctor_friendship, notice: 'Admin was successfully updated.' }
      #    format.json { render :show, status: :ok, location: @doctor_friendship }
      #  else
      #    format.html { render :edit }
      #    format.json { render json: @doctor_friendship.errors, status: :unprocessable_entity }
      #  end
      #end
    end

    # DELETE /doctor_friendships/1
    # DELETE /doctor_friendships/1.json
    def destroy
      if @doctor_friendship.destroy
        render :json => {:success => true}
      end
      #respond_to do |format|
      #  format.html { redirect_to doctor_friendships_url, notice: 'Admin was successfully destroyed.' }
      #  format.json { head :no_content }
      #end
    end
    #批量删除
    def batch_delete
      if params[:ids]
        @doctor_friendships = DoctorFriendship.where("id in (#{params[:ids].join(',')})")
        if @doctor_friendships.delete_all
          render :json => {:success => true}
        end
      end
    end

    def setting
      render template: 'doctor_friendships/setting'
    end

    private
    # Use callbacks to share common setup or constraints between actions.
    def set_doctor_friendship
      @doctor_friendship = DoctorFriendship.find(params[:id])
    end


    # Never trust parameters from the scary internet, only allow the white list through.
    def doctor_friendship_params
      params.permit(:id, :doctor1_id, :doctor2_id)
    end
  end
