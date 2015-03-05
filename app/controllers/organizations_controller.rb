class OrganizationsController < ApplicationController
  before_filter :signed_in_user
  before_action :set_organization, only: [:show, :edit, :update, :destroy]

  # GET /organizations
  # GET /organizations.json
  def index
    render :partial => 'organizations/organizations_manage'
  end

  def show_index
    sql = 'true'
    if params[:version_num] && params[:version_num] != '' && params[:version_num] != 'null'
      sql << " and version_num like '%#{params[:version_num]}%'"
    end
    @organizations = Organization.where(sql)
    count = @organizations.count
    totalpages = count % params[:rows].to_i == 0 ? count / params[:rows].to_i : count / params[:rows].to_i + 1
    if params[:page].to_i > totalpages
      params[:page] = 1
    end
    @organizations = @organizations.limit(params[:rows].to_i).offset(params[:rows].to_i*(params[:page].to_i-1))
    render :json => {:organizations => @organizations.as_json, :totalpages => totalpages, :currpage => params[:page].to_i, :totalrecords => count}
  end

  def oper_action
    if params[:oper] == 'add'
      create
    elsif params[:oper] == 'del'
      set_organization
      destroy
    elsif params[:oper] == 'edit'
      set_organization
      update
    end
  end

  # GET /organizations/1
  # GET /organizations/1.json
  def show
  end

  # GET /organizations/new
  def new
    @organization = Organization.new
  end

  # GET /organizations/1/edit
  def edit
  end

  # POST /organizations
  # POST /organizations.json
  def create
    @organization = Organization.new(organization_params)
    if @organization.save
      render :json => {:success => true}
    else
      render :json=> {:success => false, :errors => '添加失败！'}
    end

    #respond_to do |format|
    #  if @organization.save
    #    format.html { redirect_to @organization, notice: 'Admin was successfully created.' }
    #    format.json { render :show, status: :created, location: @organization }
    #  else
    #    format.html { render :new }
    #    format.json { render json: @organization.errors, status: :unprocessable_entity }
    #  end
    #end
  end

  # PATCH/PUT /organizations/1
  # PATCH/PUT /organizations/1.json
  def update
    if @organization.update(organization_params)
      render :json => {:success => true}
    else
      render :json => {:success => false, :errors => '修改失败！'}
    end
    #respond_to do |format|
    #  if @organization.update(organization_params)
    #    format.html { redirect_to @organization, notice: 'Admin was successfully updated.' }
    #    format.json { render :show, status: :ok, location: @organization }
    #  else
    #    format.html { render :edit }
    #    format.json { render json: @organization.errors, status: :unprocessable_entity }
    #  end
    #end
  end

  # DELETE /organizations/1
  # DELETE /organizations/1.json
  def destroy
   if @organization.destroy
     render :json => {:success => true}
   end
    #respond_to do |format|
    #  format.html { redirect_to organizations_url, notice: 'Admin was successfully destroyed.' }
    #  format.json { head :no_content }
    #end
  end

  def batch_delete
    if params[:ids]
      @organizations = Organization.where("id in (#{params[:ids].join(',')})")
      if @organizations.delete_all
        render :json => {:success => true}
      end
    end
  end

  def setting
    render template: 'organizations/setting'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_organization
      @organization = Organization.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def organization_params
      params.permit(:id, :name, :description, :address, :phone, :hospital_id, :department_id)
    end
end
