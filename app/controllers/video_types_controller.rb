class VideoTypesController < ApplicationController
  before_filter :signed_in_user
  before_action :set_video_type, only: [:show, :edit, :update, :destroy]

  # GET /video_types
  # GET /video_types.json
  def index
    all_menus
    render template:  'video_types/video_type_manage'
  end

  def show_index
    sql = 'true'
    if !params[:name].nil? && params[:name] != '' && params[:name] != 'null'
      sql << " and type_name like '%#{params[:name]}%'"
    end
    @video_types = VideoType.where(sql)
    count = @video_types.count
    totalpages = count % params[:rows].to_i == 0 ? count / params[:rows].to_i : count / params[:rows].to_i + 1
    if params[:page].to_i > totalpages
      params[:page] = 1
    end
    @video_types = @video_types.limit(params[:rows].to_i).offset(params[:rows].to_i*(params[:page].to_i-1))
    render :json => {:video_types => @video_types.as_json, :totalpages => totalpages, :currpage => params[:page].to_i, :totalrecords => count}
  end

  def oper_action
    if params[:oper] == 'add'
      create
    elsif params[:oper] == 'del'
      set_video_type
      destroy
    elsif params[:oper] == 'edit'
      set_video_type
      update
    end
  end

  # GET /video_types/1
  # GET /video_types/1.json
  def show
  end

  # GET /video_types/new
  def new
    @video_type = VideoType.new
  end

  # GET /video_types/1/edit
  def edit
  end

  # POST /video_types
  # POST /video_types.json
  def create
    @video_type = VideoType.new(video_type_params)
    if @video_type.save
      render :json => {:success => true}
    else
      render :json=> {:success => false, :errors => '添加失败！'}
    end

    #respond_to do |format|
    #  if @video_type.save
    #    format.html { redirect_to @video_type, notice: 'Admin was successfully created.' }
    #    format.json { render :show, status: :created, location: @video_type }
    #  else
    #    format.html { render :new }
    #    format.json { render json: @video_type.errors, status: :unprocessable_entity }
    #  end
    #end
  end

  # PATCH/PUT /video_types/1
  # PATCH/PUT /video_types/1.json
  def update
    if @video_type.update(video_type_params)
      render :json => {:success => true}
    else
      render :json => {:success => false, :errors => '修改失败！'}
    end
    #respond_to do |format|
    #  if @video_type.update(video_type_params)
    #    format.html { redirect_to @video_type, notice: 'Admin was successfully updated.' }
    #    format.json { render :show, status: :ok, location: @video_type }
    #  else
    #    format.html { render :edit }
    #    format.json { render json: @video_type.errors, status: :unprocessable_entity }
    #  end
    #end
  end

  # DELETE /video_types/1
  # DELETE /video_types/1.json
  def destroy
   if @video_type.destroy
     render :json => {:success => true}
   end
    #respond_to do |format|
    #  format.html { redirect_to video_types_url, notice: 'Admin was successfully destroyed.' }
    #  format.json { head :no_content }
    #end
  end

  def setting
    render template: 'video_types/setting'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_video_type
      @video_type = VideoType.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def video_type_params
      params.permit(:id, :type_name)
    end
end
