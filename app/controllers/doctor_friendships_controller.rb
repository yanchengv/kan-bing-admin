#encoding:utf-8
class DoctorFriendshipsController < ApplicationController
    before_action :set_doctor_friendship, only: [:show, :edit, :update, :destroy]

    # GET /doctor_friendships
    # GET /doctor_friendships.json
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
      if params[:str] == 'true'
        sql << " and id in (select doctor1_id from doctor_friendships)"
      else
        sql << " and id not in (select doctor1_id from doctor_friendships)"
      end
      @doctors = Doctor.where(sql)
      count = @doctors.count
      totalpages = count % params[:rows].to_i == 0 ? count / params[:rows].to_i : count / params[:rows].to_i + 1
      @doctors = @doctors.limit(params[:rows].to_i).offset(params[:rows].to_i*(params[:page].to_i-1))
      render :json => {:doctors => @doctors.as_json(:include => [{:hospital => {:only => [:id, :name]}},{:department => {:only => [:id, :name]}}]), :totalpages => totalpages, :currpage => params[:page].to_i, :totalrecords => count}
    end

    #获取医友信息
    def get_doctors
      if params[:doctor_id]
        @doctor_friendships = DoctorFriendship.where(:doctor1_id => params[:doctor_id])
        count = @doctor_friendships.count
        totalpages = count % params[:rows].to_i == 0 ? count / params[:rows].to_i : count / params[:rows].to_i + 1
        @doctor_friendships = @doctor_friendships.limit(params[:rows].to_i).offset(params[:rows].to_i*(params[:page].to_i-1))
        render :json => {:doctor_friendships => @doctor_friendships.as_json(:include => [{:doctor2 => {:only => [:id, :name, :gender, :hospital_name, :department_name]}}]), :totalpages => totalpages, :currpage => params[:page].to_i, :totalrecords => count}
      end
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
      if @doctor_friendship.save
        render :json => {:success => true}
      else
        render :json => {:success => false, :errors => '添加失败！'}
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
        @doctor_friendships = DoctorFriendship.where("id in #{params[:ids].to_s.gsub('[', '(').gsub(']', ')')}")
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
