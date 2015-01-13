class ApkVersionsController < ApplicationController
  before_filter :signed_in_user
  before_action :set_apk_version, only: [:show, :edit, :update, :destroy]

  # GET /apk_versions
  # GET /apk_versions.json
  def index
    render :partial => 'apk_versions/apk_versions_manage'
  end

  def show_index
    sql = 'true'
    if params[:version_num] && params[:version_num] != '' && params[:version_num] != 'null'
      sql << " and version_num like '%#{params[:version_num]}%'"
    end
    @apk_versions = ApkVersion.where(sql)
    count = @apk_versions.count
    totalpages = count % params[:rows].to_i == 0 ? count / params[:rows].to_i : count / params[:rows].to_i + 1
    if params[:page].to_i > totalpages
      params[:page] = 1
    end
    @apk_versions = @apk_versions.limit(params[:rows].to_i).offset(params[:rows].to_i*(params[:page].to_i-1))
    render :json => {:apk_versions => @apk_versions.as_json, :totalpages => totalpages, :currpage => params[:page].to_i, :totalrecords => count}
  end

  def oper_action
    if params[:oper] == 'add'
      create
    elsif params[:oper] == 'del'
      set_apk_version
      destroy
    elsif params[:oper] == 'edit'
      set_apk_version
      update
    end
  end

  # GET /apk_versions/1
  # GET /apk_versions/1.json
  def show
  end

  # GET /apk_versions/new
  def new
    @apk_version = ApkVersion.new
  end

  # GET /apk_versions/1/edit
  def edit
  end

  # POST /apk_versions
  # POST /apk_versions.json
  def create
    @apk_version = ApkVersion.new(apk_version_params)
    if @apk_version.save
      render :json => {:success => true}
    else
      render :json=> {:success => false, :errors => '添加失败！'}
    end

    #respond_to do |format|
    #  if @apk_version.save
    #    format.html { redirect_to @apk_version, notice: 'Admin was successfully created.' }
    #    format.json { render :show, status: :created, location: @apk_version }
    #  else
    #    format.html { render :new }
    #    format.json { render json: @apk_version.errors, status: :unprocessable_entity }
    #  end
    #end
  end

  # PATCH/PUT /apk_versions/1
  # PATCH/PUT /apk_versions/1.json
  def update
    if @apk_version.update(apk_version_params)
      render :json => {:success => true}
    else
      render :json => {:success => false, :errors => '修改失败！'}
    end
    #respond_to do |format|
    #  if @apk_version.update(apk_version_params)
    #    format.html { redirect_to @apk_version, notice: 'Admin was successfully updated.' }
    #    format.json { render :show, status: :ok, location: @apk_version }
    #  else
    #    format.html { render :edit }
    #    format.json { render json: @apk_version.errors, status: :unprocessable_entity }
    #  end
    #end
  end

  # DELETE /apk_versions/1
  # DELETE /apk_versions/1.json
  def destroy
   if @apk_version.destroy
     render :json => {:success => true}
   end
    #respond_to do |format|
    #  format.html { redirect_to apk_versions_url, notice: 'Admin was successfully destroyed.' }
    #  format.json { head :no_content }
    #end
  end

  def batch_delete
    if params[:ids]
      @apk_versions = ApkVersion.where("id in (#{params[:ids].join(',')})")
      if @apk_versions.delete_all
        render :json => {:success => true}
      end
    end
  end

  def setting
    render template: 'apk_versions/setting'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_apk_version
      @apk_version = ApkVersion.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def apk_version_params
      params.permit(:id, :version_num, :version_url, :description, :update_time)
    end
end
