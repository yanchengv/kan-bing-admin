class EduVideosController < ApplicationController
  require 'rubygems'
  require 'mini_magick'
  require 'curb'
  require 'fileutils'
  require 'httparty'
  include HTTParty
  before_action :set_edu_video, only: [:show, :edit, :update, :destroy]

  # GET /edu_videos
  # GET /edu_videos.json
  def index
  end

  def show_index
    sql = 'true'
    #if !params[:name].nil? && params[:name] != '' && params[:name] != 'null'
    #  sql << " and (name like '%#{params[:name]}%' or spell_code like '%#{params[:name]}%' or short_name like '%#{params[:name]}%')"
    #end
    @edu_videos = EduVideo.where(sql)
    count = @edu_videos.count
    totalpages = count % params[:rows].to_i == 0 ? count / params[:rows].to_i : count / params[:rows].to_i + 1
    @edu_videos = @edu_videos.limit(params[:rows].to_i).offset(params[:rows].to_i*(params[:page].to_i-1))
    render :json => {:edu_videos => @edu_videos.as_json(:include => [{:doctor => {:only => [:id, :name]}}, {:video_type => {:only => [:id, :type_name]}}]), :totalpages => totalpages, :currpage => params[:page].to_i, :totalrecords => count}
  end

  def oper_action
    if params[:oper] == 'add'
      create
    elsif params[:oper] == 'del'
      set_edu_video
      destroy
    elsif params[:oper] == 'edit'
      set_edu_video
      update
    end
  end

  # GET /edu_videos/1
  # GET /edu_videos/1.json
  def show
  end

  # GET /edu_videos/new
  def new
    @edu_video = EduVideo.new
  end

  # GET /edu_videos/1/edit
  def edit
  end

  #上传图片
  def upload_image
    random=SecureRandom.random_number(9999999999)
    image_tmp_path='public/'+random.to_s+'.jpg'
    image_tmp=params[:edu_video][:image]
    image = MiniMagick::Image.open(image_tmp.path)
    image.resize '224x150!'
    image.write image_tmp_path
    c = Curl::Easy.new(Settings.files)
    c.multipart_form_post = true
    c.http_post(Curl::PostField.file('theFile', image_tmp_path))
    response=JSON.parse(c.body_str)
    @data=''
    if response['files']&&response['files'][0]['name']
      FileUtils.remove_file image_tmp_path
      uuid=response['files'][0]['name']
      render :json => {flag: true, url: uuid}

    else
      render :json => {flag: false, url: ''}
    end
  end

  # POST /edu_videos
  # POST /edu_videos.json
  def create
    @edu_video = EduVideo.new(edu_video_params)
    if @edu_video.save
      render :json => {:success => true}
    else
      render :json=> {:success => false, :errors => '添加失败！'}
    end

    #respond_to do |format|
    #  if @edu_video.save
    #    format.html { redirect_to @edu_video, notice: 'Admin was successfully created.' }
    #    format.json { render :show, status: :created, location: @edu_video }
    #  else
    #    format.html { render :new }
    #    format.json { render json: @edu_video.errors, status: :unprocessable_entity }
    #  end
    #end
  end

  # PATCH/PUT /edu_videos/1
  # PATCH/PUT /edu_videos/1.json
  def update
    if @edu_video.update(edu_video_params)
      render :json => {:success => true}
    else
      render :json => {:success => false, :errors => '修改失败！'}
    end
    #respond_to do |format|
    #  if @edu_video.update(edu_video_params)
    #    format.html { redirect_to @edu_video, notice: 'Admin was successfully updated.' }
    #    format.json { render :show, status: :ok, location: @edu_video }
    #  else
    #    format.html { render :edit }
    #    format.json { render json: @edu_video.errors, status: :unprocessable_entity }
    #  end
    #end
  end

  # DELETE /edu_videos/1
  # DELETE /edu_videos/1.json
  def destroy
   if @edu_video.destroy
     render :json => {:success => true}
   end
    #respond_to do |format|
    #  format.html { redirect_to edu_videos_url, notice: 'Admin was successfully destroyed.' }
    #  format.json { head :no_content }
    #end
  end
  #获取医生
  def get_doctors
    @doctors = Doctor.all
    docs = {}
    @doctors.each do |doc|
      docs[doc.id] = doc.name
    end
    render :json => {:doctors => docs.as_json}
  end

  #获取视频类型
  def get_video_types
    @video_types = VideoType.all
    types = {}
    @video_types.each do |type|
      types[type.id] = type.type_name
    end
    render :json => {:video_types => types.as_json}
  end
  def setting
    render template: 'edu_videos/setting'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_edu_video
      @edu_video = EduVideo.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def edu_video_params
      params.permit(:id, :name, :content, :doctor_name, :video_time, :image_url, :video_url, :doctor_id, :video_type_id)
    end
end
