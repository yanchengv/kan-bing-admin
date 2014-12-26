class EduVideosController < ApplicationController
  before_filter :signed_in_user,:except => [:upload_video2]
  skip_before_filter :verify_authenticity_token , :only => [:upload_video2]
  require 'rubygems'
  require 'mini_magick'
  require 'curb'
  require 'fileutils'
  require 'httparty'
  include HTTParty
  before_action :set_edu_video, only: [:show, :edit, :destroy]

  # GET /edu_videos
  # GET /edu_videos.json
  def index
    @video_types = VideoType.all

    render partial: 'edu_videos/edu_video_manage'
  end

  def show_index
    sql = 'true'
    hos_id = current_user.hospital_id
    dep_id = current_user.department_id
    if !hos_id.nil? && hos_id != ''
      if !dep_id.nil? && dep_id != ''
        doc = "select id from doctors where hospital_id=#{hos_id} and department_id=#{dep_id}"
        @doctors = Doctor.select("id").where(hospital_id:hos_id,department_id:dep_id)
        # sql << " and hospital_id=#{hos_id} and department_id=#{dep_id}"
      else
        doc = "select id from doctors where hospital_id=#{hos_id}"
        @doctors = Doctor.select("id").where(hospital_id:hos_id)
        # sql << " and hospital_id=#{hos_id}"
      end
      sql << " and doctor_id in ("+doc+")"
    end
    if !params[:type].nil? && params[:type] != '0' && params[:type] != 'null'
      sql << " and video_type_id = #{params[:type]}"
    end
    if !params[:name].nil? && params[:name] != '' && params[:name] != 'null'
      sql << " and name like '%#{params[:name]}%'"
    end
    @edu_videos = EduVideo.where(sql).order('created_at desc')
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

    file=params[:edu_video].nil? ? params[:image] : params[:edu_video][:image]
    tmpfile = getFileName(file.original_filename.to_s)
    uuid = uploadToAliyun(file,Settings.aliyunOSS.video_service,Settings.aliyunOSS.image_bucket)
    if true
      render :json => {flag: true, url: uuid}
    else
      render :json => {flag: false, url: ''}
    end
  end

  #上传视频
  def upload_video
    file=params[:edu_video].nil? ? params[:video] : params[:edu_video][:video]
    p file.original_filename
    tmpfile = getFileName(file.original_filename.to_s)
    service = Settings.aliyunOSS.video_service
    bucket = Settings.aliyunOSS.video_bucket
    uuid = uploadToAliyun(file,service,bucket)
    if true
      render :json => {flag: true, url: uuid}
    else
      render :json => {flag: false, url: ''}
    end
  end

  def upload_video2
    file=params[:video]
    p file.original_filename
    tmpfile = getFileName(file.original_filename.to_s)
    uuid = uploadToAliyun(file,Settings.aliyunOSS.video_service,Settings.aliyunOSS.video_bucket)
    if true
      render :json => {flag: true, url: uuid}
    else
      render :json => {flag: false, url: ''}
    end
  end

  def upload
    para={}
    para[:name]=params[:name]
    para[:content]=params[:content]
    para[:video_url]=params[:video_url]
    para[:doctor_id]=params[:doctor_id]
    para[:hospital_id]=current_user.hospital_id
    para[:department_id]=current_user.department_id
    if !params[:doctor_id].nil?
      @doc = Doctor.find_by_id(params[:doctor_id])
      if !@doc.nil?
        para[:doctor_name]=@doc.name
      end
    end
    para[:video_time]=params[:video_time]
    para[:image_url]= params[:image_url]
    para[:video_type_id]=params[:video_type_id]
    @video=EduVideo.new(para)
    if @video.save
      @video_types = VideoType.all
      render :partial => 'edu_videos/edu_video_manage'
    else
      @doctors = Doctor.all
      @types=VideoType.all
      @video=EduVideo.new
      render :partial => 'edu_videos/create'
    end
  end

  def video_edit
    @video = EduVideo.find(params[:id])
    @doc = Doctor.find_by_id(params[:doctor_id])
    if !@video.video_url.nil? && (@video.video_url != params[:video_url])
      delte_video_file_from_aliyun(@video.video_url)  #删除之前的file
    end
    if !@video.image_url.nil? && (@video.image_url != params[:image_url])
      delte_video_file_from_aliyun(@video.image_url)
    end
    if @video.update_attributes(:name => params[:name], :content => params[:content], :doctor_name => @doc.nil? ? '' : @doc.name,
                                :video_time => params[:video_time], :image_url => params[:image_url], :video_url => params[:video_url],
                                :doctor_id => params[:doctor_id], :video_type_id => params[:video_type_id])
      @video_types = VideoType.all
      render :partial => 'edu_videos/edu_video_manage'
    else
      @doctors = Doctor.all
      @types=VideoType.all
      render :partial => 'edu_videos/edit_video'
    end
  end

  def new_video
    if !current_user.nil?
      hos_id = current_user.hospital_id
      dep_id = current_user.department_id
      if !hos_id.nil? && hos_id != ''
        if !dep_id.nil? && dep_id != ''
          @doctors = Doctor.where(hospital_id:hos_id,department_id:dep_id)
        else
          @doctors = Doctor.where(hospital_id:hos_id)
        end
      else
        @doctors = Doctor.select("id","name").all
      end
      @types=VideoType.all
      @video=EduVideo.new
    end
    render :partial => 'edu_videos/create'
  end

  def edit_video
    if !current_user.nil?
      hos_id = current_user.hospital_id
      dep_id = current_user.department_id
      if !hos_id.nil? && hos_id != ''
        if !dep_id.nil? && dep_id != ''
          @doctors = Doctor.where(hospital_id:hos_id,department_id:dep_id)
        else
          @doctors = Doctor.where(hospital_id:hos_id)
        end
      else
        @doctors = Doctor.select("id","name").all
      end
      @types=VideoType.all
      @video=EduVideo.find(params[:id])
    end
    render :partial => 'edu_videos/edit_video'
  end
  # POST /edu_videos
  # POST /edu_videos.json
  def create
    respond_to do |format|
      if @edu_video.save
        format.html { redirect_to @edu_video, notice: 'Admin was successfully created.' }
        format.json { render :show, status: :created, location: @edu_video }
      else
        format.html { render :new }
        format.json { render json: @edu_video.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /edu_videos/1
  # PATCH/PUT /edu_videos/1.json
  def update
    respond_to do |format|
      if @edu_video.update(edu_video_params)
        format.html { redirect_to @edu_video, notice: 'Admin was successfully updated.' }
        format.json { render :show, status: :ok, location: @edu_video }
      else
        format.html { render :edit }
        format.json { render json: @edu_video.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /edu_videos/1
  # DELETE /edu_videos/1.json
  def destroy
    if !@edu_video.image_url.nil?
      delte_video_file_from_aliyun(@edu_video.image_url) #删除对应的缩略图
    end
    if !@edu_video.video_url.nil?
      delte_video_file_from_aliyun(@edu_video.video_url) #删除对应的视频
    end
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
