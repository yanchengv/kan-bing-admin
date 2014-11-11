class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include SessionsHelper
  require 'aliyun/oss'
  require 'open-uri'
  require 'aliyun/oss/bucket'
  include Aliyun::OSS

  SERVER = Settings.aliyunOSS.server
  OSSKEY = Settings.aliyunOSS.access_key_id
  SECRET_KEY = Settings.aliyunOSS.secret_access_key
  BUCKET = Settings.aliyunOSS.video_bucket
  def access_flag
    menu_name = params[:menu_name]
    flag=false
    @menu_permissions = MenuPermission.joins(role2s_menu_permissions:[{role2: [{admin2s_role2s: :admin2}]}]).where(admin2s:{id:current_user.id})
    if !@menu_permissions.empty?
      @menu_permissions.each do |menu_permission|
        if menu_permission.menu.name == menu_name
          flag = true
        end
      end
    end
    return flag
  end

  def access_control
    unless access_flag
      store_location
      redirect_to root_path, notice: "Please sign in."
    end

  end

  def upload_video_img_bucket(file)
    if !file.original_filename.empty?
      Aliyun::OSS::Base.establish_connection!(
          :server => SERVER, #可不填,默认为此项
          :access_key_id => OSSKEY,
          :secret_access_key => SECRET_KEY
      )

      video_image_bucket = Bucket.find(BUCKET) #查找Bucket
      obj = video_image_bucket.new_object #在此Bucket新建Object
      obj.key = getFileName(file.original_filename)
      #obj.key = file
      obj.value= open(file)
      obj.store
      return obj.key
    end
  end


  def getFileName(filename)
    if !filename.nil?
      require 'uuidtools'
      prefix = UUIDTools::UUID.random_create.to_s
      last_fix_index = filename.rindex('.')
      last_fix = filename[last_fix_index..-1]

      filename = prefix.to_s + last_fix.to_s
    end
  end

  # delete object by filename
  def delte_file_from_aliyun(file)
    Aliyun::OSS::Base.establish_connection!(
        :server => SERVER, #可不填,默认为此项
        :access_key_id => OSSKEY,
        :secret_access_key => SECRET_KEY
    )
   # mimas_open_bucket = Bucket.find(BUCKET) #查找Bucket
    begin
      OSSObject.delete(file, 'dev_mimas') #删除文件
    rescue
      puts 'delte  error'
    end
  end


end
