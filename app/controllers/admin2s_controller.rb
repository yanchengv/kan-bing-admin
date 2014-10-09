class Admin2sController < ApplicationController
  before_action :set_admin, only: [:show, :edit, :update, :destroy]

  # GET /admins
  # GET /admins.json
  def index
  end

  def test_index
    sql = 'true'
    if params[:name] && params[:name] != ''
      sql << " and name like '%#{params[:name]}%'"
    end
    if params[:email] && params[:email] != ''
      sql << " and email like '%#{params[:email]}%'"
    end
    if params[:photo] && params[:photo] != ''
      sql << " and photo like '%#{params[:photo]}%'"
    end
    @admins = Admin2.where(sql)
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
    if @admin.update(admin_params)
      render :json => {:success => true}
    else
      render :json => {:success => false, :errors => '修改失败！'}
    end
    #respond_to do |format|
    #  if @admin.update(admin_params)
    #    format.html { redirect_to @admin, notice: 'Admin was successfully updated.' }
    #    format.json { render :show, status: :ok, location: @admin }
    #  else
    #    format.html { render :edit }
    #    format.json { render json: @admin.errors, status: :unprocessable_entity }
    #  end
    #end
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
    render template: 'admin2s/setting'
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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_admin
      @admin = Admin2.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def admin_params
      params.permit(:id, :name, :email, :photo,:password, :mobile_phone, :password_digest, :remember_token, :reset_password_token, :reset_password_sent_at, :remember_created_at, :sign_in_count, :current_sign_in_at, :last_sign_in_at, :current_sign_in_ip, :last_sign_in_ip, :confirmation_token, :confirmed_at, :confirmation_sent_at, :unconfirmed_email, :failed_attempts, :unlock_token, :locked_at)
    end
end
