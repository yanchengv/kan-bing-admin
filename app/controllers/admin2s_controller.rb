class Admin2sController < ApplicationController
  before_filter :signed_in_user
  before_action :set_admin, only: [:show, :edit, :update, :destroy]

  # GET /admins
  # GET /admins.json
  def index

    all_menus
    render template:  'admin2s/admin_manage'
  end

  def test_index

    if params[:admin_type] == 'hos_admin'
      admin_type = '医院管理员'
    elsif params[:admin_type] == 'dep_admin'
      admin_type = '科室管理员'
    elsif params[:admin_type] == 'web_admin'
      admin_type = '网站管理员'
    elsif params[:admin_type] == 'ins_admin'
      admin_type = '机构管理员'
    end
    sql = 'true'
    if current_user.admin_type == '医院管理员'
      sql = "hospital_id = #{current_user.hospital_id}"
    end
    if admin_type
      sql << " and admin_type = '#{admin_type}'"
    end
    if params[:name] && params[:name] != ''
      sql << " and name like '%#{params[:name]}%'"
    end
    if params[:email] && params[:email] != ''
      sql << " and email like '%#{params[:email]}%'"
    end
    if params[:mobile_phone] && params[:mobile_phone] != ''
      sql << " and mobile_phone like '%#{params[:mobile_phone]}%'"
    end
    @admins = Admin2.where(sql)
    count = @admins.count
    totalpages = count % params[:rows].to_i == 0 ? count / params[:rows].to_i : count / params[:rows].to_i + 1
    if params[:page].to_i > totalpages
      params[:page] = 1
    end
    @admins = @admins.limit(params[:rows].to_i).offset(params[:rows].to_i*(params[:page].to_i-1))
    render :json => {:admin2s => @admins.as_json, :totalpages => totalpages, :currpage => params[:page].to_i, :totalrecords => count}
  end

  def web_admin_show
    @admins = Admin2.where(id:params[:admin_id])
    # @admins = Admin2.where(admin_type: '网站管理员')
    count = @admins.count
    totalpages = count % params[:rows].to_i == 0 ? count / params[:rows].to_i : count / params[:rows].to_i + 1
    @admins = @admins.limit(params[:rows].to_i).offset(params[:rows].to_i*(params[:page].to_i-1))
    render :json => {:admin2s => @admins.as_json, :totalpages => totalpages, :currpage => params[:page].to_i, :totalrecords => count}
  end

  def oper_action
    if params[:oper] == 'add'
      create
    elsif params[:oper] == 'del'
      set_admin
      destroy
    elsif params[:oper] == 'edit'
      set_admin
      update
    end
  end

  # GET /admins/1
  # GET /admins/1.json
  def show
  end

  # GET /admins/new
  def new
    @admin = Admin2.new
  end

  # GET /admins/1/edit
  def edit
  end

  # POST /admins
  # POST /admins.json
  def create
    if params[:admin_type] == '机构管理员'
      # ins_hos_id = pk_id_rules
      # if !params[:hos_id].nil? && params[:hos_id] != ''
      #   ins_hos_id = params[:hos_id]
      # end
      # params[:hospital_id] = ins_hos_id
      # ins_dep_id = params[:hospital_id]
      # # if !params[:dep_id].nil? && params[:dep_id] != ''
      # #   ins_dep_id = params[:dep_id]
      # # end
      # params[:department_id] = ins_dep_id
      @organization = Organization.where(id:params[:organization_id]).first
      if !@organization.nil?
        params[:hospital_id] = @organization.hospital_id
        params[:department_id] = @organization.department_id
      end
    end

    @admin = Admin2.new(admin_params)
    if @admin.password.nil? || @admin.password == ''
      @admin.password = '123456'
    end
    if @admin.save
      render :json => {:success => true}
    else
      render :json=> {:success => false, :errors => '添加失败！'}
    end

    #respond_to do |format|
    #  if @admin.save
    #    format.html { redirect_to @admin, notice: 'Admin was successfully created.' }
    #    format.json { render :show, status: :created, location: @admin }
    #  else
    #    format.html { render :new }
    #    format.json { render json: @admin.errors, status: :unprocessable_entity }
    #  end
    #end
  end

  # PATCH/PUT /admins/1
  # PATCH/PUT /admins/1.json
  def update
    if params[:password].nil? && params[:password] == ''    #密码为空时,表示不修改密码
      params[:password] = @admin.password
    end
    if @admin.update(admin_params)
      render :json => {:success => true}
    else
      render :json => {:success => false, :errors => '修改失败！'}
    end
  end

  def get_by_email
    @admins = Admin2.where(:email => params[:email])
    if @admins.empty?
      render :json => {:success => true}
    else
      render :json => {:success => false, :errors => '邮箱已被注册,请更改！'}
    end
  end

  # DELETE /admins/1
  # DELETE /admins/1.json
  def destroy
   if @admin.destroy
     render :json => {:success => true}
   end
    #respond_to do |format|
    #  format.html { redirect_to admins_url, notice: 'Admin was successfully destroyed.' }
    #  format.json { head :no_content }
    #end
  end

  def setting
    all_menus
    # render template: 'admin2s/setting'
    render template:  'admin2s/setting_form'
  end

  def password_update
    old_password = params[:admin][:old_password]
    new_password = params[:admin][:new_password]
    confirm_password = params[:admin][:password_confirmation]
    if current_user.authenticate(old_password) == false
      @js={:pd=>'old_false'}
      respond_to do |format|
        format.html
        format.json  {render json: @js }
        format.js
      end
    else
      current_user.update_attribute(:password, new_password)
      sign_in current_user
      @js={:pd=>'true'}
      respond_to do |format|
        format.html
        format.json  {render json: @js }
        format.js
      end
    end
  end

  def get_admin2
    @admin2 = Admin2.find_by(id:params[:admin_id])
    if !@admin2.nil?
      if !@admin2.department.nil?
        @admin2 = {id:@admin2.id,name:@admin2.name,email:@admin2.email,mobile_phone:@admin2.mobile_phone,department_id:@admin2.department_id,department_name:@admin2.department.name,hospital_id:@admin2.hospital_id}
      end
      render json: {success:true, data:@admin2}
    else
      render json: {success:false}
    end
  end

  def get_admin_type
    types = {}
    if current_user.admin_type == '医院管理员'
      types['科室管理员']='科室管理员'
      types['医院管理员']='医院管理员'
    elsif current_user.admin_type == '科室管理员'
      types['科室管理员']='科室管理员'
    else
      types['科室管理员']='科室管理员'
      types['医院管理员']='医院管理员'
      types['网站管理员']='网站管理员'
      types['机构管理员']='机构管理员'
    end
    render :json => {:admin_type => types.as_json}
  end

  def get_ins_hos
    admins = {}
    admins[''] = '其他机构'
    @admin2s = Admin2.select("hospital_id","introduction").where(admin_type: '机构管理员')
    if !@admin2s.empty?
      @admin2s.each do |admin|
        if !admin.introduction.nil? && admin.introduction != ''
          admins[admin.hospital_id] = admin.hospital_id.to_s+'('+admin.introduction.to_s+')'
        else
          admins[admin.hospital_id] = admin.hospital_id.to_s
        end
      end
    end
    render :json => {:admins => admins.as_json}
  end

  def check_old_pwd   #修改密码时验证原密码是否正确
    if current_user.authenticate(params[:old_password])
      render json:{success:true,content:'原密码正确！'}
    else
      render json:{success:false,content:'原密码错误！'}
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_admin
      @admin = Admin2.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def admin_params
      params.permit(:id, :name, :email, :photo,:password,:organization_id,:hospital_id,:department_id,:admin_type, :mobile_phone, :password_digest, :remember_token, :reset_password_token, :reset_password_sent_at, :remember_created_at, :sign_in_count, :current_sign_in_at, :last_sign_in_at, :current_sign_in_ip, :last_sign_in_ip, :confirmation_token, :confirmed_at, :confirmation_sent_at, :unconfirmed_email, :failed_attempts, :unlock_token, :locked_at, :introduction)
      # params.require(:home_menu).permit(:id,:name,:parent_id,:hospital_id,:department_id,:content,:show_in_menu,:link_url,:skip_to_first_child,:show_in_header,:show_in_footer,:depth)

    end
end
