class DataSourcesController < ApplicationController
  before_filter :signed_in_user
  before_action :set_data_source, only: [:show, :edit, :update, :destroy]

  # GET /data_sources
  # GET /data_sources.json
  def index
    all_menus
    render :template => 'data_sources/data_sources_manage'
  end

  def show_index
    sql = 'true'
    if params[:name] && params[:name] != '' && params[:name] != 'null'
      sql << " and name like '%#{params[:name]}%'"
    end
    if params[:hospital] && params[:hospital] != '' && params[:hospital] != 'null'
      sql << " and hospital like '%#{params[:hospital]}%'"
    end
    if params[:department] && params[:department] != '' && params[:department] != 'null'
      sql << " and department like '%#{params[:department]}%'"
    end
    if params[:data_source_number] && params[:data_source_number] != '' && params[:data_source_number] != 'null'
      sql << " and data_source_number like '%#{params[:data_source_number]}%'"
    end
    if params[:deploy_people] && params[:deploy_people] != '' && params[:deploy_people] != 'null'
      sql << " and deploy_people like '%#{params[:deploy_people]}%'"
    end
    @data_sources = DataSource.where(sql)
    count = @data_sources.count
    totalpages = count % params[:rows].to_i == 0 ? count / params[:rows].to_i : count / params[:rows].to_i + 1
    if params[:page].to_i > totalpages
      params[:page] = 1
    end
    @data_sources = @data_sources.limit(params[:rows].to_i).offset(params[:rows].to_i*(params[:page].to_i-1))
    render :json => {:data_sources => @data_sources.as_json, :totalpages => totalpages, :currpage => params[:page].to_i, :totalrecords => count}
  end

  def oper_action
    if params[:oper] == 'add'
      create
    elsif params[:oper] == 'del'
      set_data_source
      destroy
    elsif params[:oper] == 'edit'
      set_data_source
      update
    end
  end

  # GET /data_sources/1
  # GET /data_sources/1.json
  def show
  end

  # GET /data_sources/new
  def new
    @data_source = DataSource.new
  end

  # GET /data_sources/1/edit
  def edit
  end

  # POST /data_sources
  # POST /data_sources.json
  def create
    @data_source = DataSource.new(data_source_params)
    if @data_source.save
      render :json => {:success => true}
    else
      render :json=> {:success => false, :errors => '添加失败！'}
    end

    #respond_to do |format|
    #  if @data_source.save
    #    format.html { redirect_to @data_source, notice: 'Admin was successfully created.' }
    #    format.json { render :show, status: :created, location: @data_source }
    #  else
    #    format.html { render :new }
    #    format.json { render json: @data_source.errors, status: :unprocessable_entity }
    #  end
    #end
  end

  # PATCH/PUT /data_sources/1
  # PATCH/PUT /data_sources/1.json
  def update
    if @data_source.update(data_source_params)
      render :json => {:success => true}
    else
      render :json => {:success => false, :errors => '修改失败！'}
    end
    #respond_to do |format|
    #  if @data_source.update(data_source_params)
    #    format.html { redirect_to @data_source, notice: 'Admin was successfully updated.' }
    #    format.json { render :show, status: :ok, location: @data_source }
    #  else
    #    format.html { render :edit }
    #    format.json { render json: @data_source.errors, status: :unprocessable_entity }
    #  end
    #end
  end

  # DELETE /data_sources/1
  # DELETE /data_sources/1.json
  def destroy
   if @data_source.destroy
     render :json => {:success => true}
   end
    #respond_to do |format|
    #  format.html { redirect_to data_sources_url, notice: 'Admin was successfully destroyed.' }
    #  format.json { head :no_content }
    #end
  end

  def batch_delete
    if params[:ids]
      @data_sources = DataSource.where("id in (#{params[:ids].join(',')})")
      if @data_sources.delete_all
        render :json => {:success => true}
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_data_source
      @data_source = DataSource.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def data_source_params
      params.permit(:id, :name, :content, :hospital, :department, :data_source_number, :deploy_people, :created_at)
    end
end
