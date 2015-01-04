class PhotosController < ApplicationController
  require 'rubygems'
  require 'mini_magick'
  require 'curb'
  require 'fileutils'

  def create
    @user=User.new
    uuid=@user.uuid('.jpg')
    image_path=@user.create_folder_by_uuid(uuid)
    tmp=params[:photo][:photo]
    file=params[:photo][:photo]
    x=params[:x].to_i
    y=params[:y].to_i
    h=params[:h].to_i
    w=params[:w].to_i
    image = MiniMagick::Image.open(tmp.path)
    image.crop "#{w}x#{h}+#{x}+#{y}"
    image.resize '150x210'
    tmpfile = getFileName(file.original_filename.to_s)
    image.write tmpfile
    uuid = uploadFileToAliyun(tmpfile)
    @data=''

    # TODO file.exits? in aliyun
    if File.exist?(image_path)  || true
      #pic_url = Settings.pic+uuid
      default_access_url_prefix = Settings.aliyunOSS.photo_url
      p default_access_url_prefix
      pic_url = default_access_url_prefix + uuid.to_s
      @data={flag:true,url:pic_url,image_path:uuid}
      # old_photo = ""
      # if !current_user.doctor_id.nil?
      #   old_photo =current_user.doctor.photo
      #   current_user.doctor.update_attributes(photo: uuid)
      # elsif !current_user.patient_id.nil?
      #   old_photo =current_user.patient.photo
      #   current_user.patient.update_attributes(photo: uuid)
      # end
      #   #delete the old photo from aliyun
      #   delte_file_from_aliyun(old_photo)

    else
      @data={flag: false, url: ''}
    end
    #@data ={data:'123'}
    render json: @data
  end
end