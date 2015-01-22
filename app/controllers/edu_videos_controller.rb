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
    if params[:page].to_i > totalpages
      params[:page] = 1
    end
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
    uuid = uploadToAliyun(file,Settings.aliyunOSS.beijing_service,Settings.aliyunOSS.image_bucket)
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
    service = Settings.aliyunOSS.beijing_service
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
    uuid = uploadToAliyun(file,Settings.aliyunOSS.beijing_service,Settings.aliyunOSS.video_bucket)
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
    para[:hospital_id] = params[:hospital_id]
    para[:department_id] = params[:department_id]
    if params[:view_permission].nil? || params[:view_permission]==''
      params[:view_permission]='公开'
    end
    para[:view_permission] = params[:view_permission]
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
    service = Settings.aliyunOSS.beijing_service
    if !@video.video_url.nil? && (@video.video_url != params[:video_url]) && @video.video_url != ''
      deleteFromAliyun(@video.video_url,service,Settings.aliyunOSS.video_bucket) #删除对应的视频
    end
    if !@video.image_url.nil? && (@video.image_url != params[:image_url]) && @video.image_url != ''
      deleteFromAliyun(@video.image_url,service,Settings.aliyunOSS.image_bucket) #删除对应的缩略图
    end
    hospital_id = params[:hospital_id]
    department_id = params[:department_id]
    if @video.update_attributes(:name => params[:name], :content => params[:content], :doctor_name => @doc.nil? ? '' : @doc.name,
                                :video_time => params[:video_time], :image_url => params[:image_url], :video_url => params[:video_url],
                                :doctor_id => params[:doctor_id], :video_type_id => params[:video_type_id], :hospital_id => hospital_id, :department_id => department_id,:view_permission => params[:view_permission])
      @video_types = VideoType.all
      render :partial => 'edu_videos/edu_video_manage'
    else
      @doctors = Doctor.all
      @types=VideoType.all
      render :partial => 'edu_videos/edit_video'
    end
  end

  def video_delete #上传或修改视频时，点击取消按钮执行 #params[:video_url]和params[:image_url]两个都空自然不会调用该方法
    @video = EduVideo.where(id:params[:video_id]).first
    service = Settings.aliyunOSS.beijing_service
    if !@video.nil?
      if @video.image_url != params[:image_url]
        bucket = Settings.aliyunOSS.image_bucket
        deleteFromAliyun(params[:image_url],service,bucket) #删除对应的缩略图
      end
      if @video.video_url != params[:video_url]
        bucket = Settings.aliyunOSS.video_bucket
        deleteFromAliyun(params[:video],service,bucket) #删除对应的视频
      end
    else
      if !params[:image_url].nil? && params[:image_url] != ''
        deleteFromAliyun(params[:image_url],service,Settings.aliyunOSS.image_bucket) #删除对应的缩略图
      end
      if !params{:video_url}.nil? && params[:video_url] != ''
        deleteFromAliyun(params[:video_url],service,Settings.aliyunOSS.video_bucket) #删除对应的视频
      end
    end
    render json: {success:true}
  end

  def new_video
    if !current_user.nil?
      hos_id = current_user.hospital_id
      dep_id = current_user.department_id
      if !hos_id.nil? && hos_id != ''
        if !dep_id.nil? && dep_id != ''
          @doctors = Doctor.select("id","name").where(hospital_id:hos_id,department_id:dep_id)
          @departments = Department.select("id","name").where(id:dep_id)
        else
          @departments = Department.select("id","name").where(hospital_id:hos_id)
          @doctors = Doctor.select("id","name").where(hospital_id:hos_id).order("name")
        end
        @hospitals = Hospital.select("id","name").where(id:hos_id)
      else
        @hospitals = Hospital.select("id","name").all
        #   @doctors = Doctor.select("id","name").all
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
          @doctors = Doctor.select("id","name").where(hospital_id:hos_id,department_id:dep_id)
          @departments = Department.select("id","name").where(id:dep_id)
        else
          @departments = Department.select("id","name").where(hospital_id:hos_id)
          @doctors = Doctor.select("id","name").where(hospital_id:hos_id).order("name")
        end
      else
        @hospitals = Hospital.select("id","name").all
        # @doctors = Doctor.select("id","name").all
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
    service = Settings.aliyunOSS.beijing_service
    if !@edu_video.image_url.nil? && !@edu_video.image_url != ''
      bucket = Settings.aliyunOSS.image_bucket
      deleteFromAliyun(@edu_video.image_url,service,bucket) #删除对应的缩略图
    end
    if !@edu_video.video_url.nil? && @edu_video.video_url != ''
      bucket = Settings.aliyunOSS.video_bucket
      deleteFromAliyun(@edu_video.image_url,service,bucket) #删除对应的视频
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

  def search_department
    @departments = Department.where(hospital_id:params[:hos_id])
    if params[:hos_id].nil? || params[:hos_id]=='' || params[:hos_id] == 'all'
      @departments=nil
    end
    if !current_user.department_id.nil? && current_user.department_id != ''
      @departments = Department.select("id","name").where(id:current_user.department_id)
    end
    @video = EduVideo.where(id:params[:video_id]).first
    render partial: 'edu_videos/search_department'
  end

  def search_doctor
    if params[:hos_id] == 'all'
      @doctors = Doctor.select("id","name").all
    else
      if params[:dep_id] == 'all'
        @doctors = Doctor.select("id","name").where(hospital_id:params[:hos_id]).order("name")
      else
        @doctors = Doctor.select("id","name").where(hospital_id:params[:hos_id],department_id:params[:dep_id]).order("name")
      end
    end
    if !current_user.department_id.nil? && current_user.department_id != ''
      @doctors = Doctor.where(department_id:current_user.department_id).order("name")
    end
    @video = EduVideo.where(id:params[:video_id]).first
    render partial: 'edu_videos/search_doctor'
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_edu_video
      @edu_video = EduVideo.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def edu_video_params
      params.permit(:id, :name, :content, :doctor_name, :video_time, :image_url, :video_url, :doctor_id, :video_type_id,:view_permission,:department_id,:hospital_id)
    end
end
