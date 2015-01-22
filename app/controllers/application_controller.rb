class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include SessionsHelper
  require 'aliyun/oss'
  require 'open-uri'
  require 'aliyun/oss/bucket'
  include Aliyun::OSS
  before_filter :session_expiry
  before_filter :update_activity_time

  def session_expiry
    @time_left = (session[:expires_at].to_time - Time.now.to_time).to_i
    unless @time_left > 0
      # reset_session
      sign_out
      redirect_to '/sessions/sign_in'
    end
  end

  def update_activity_time
    session[:expires_at] = 15.minutes.from_now
  end

  def access_flag
    menu_name = params[:menu_name]
    flag=false
    @menu_permissions = MenuPermission.joins(role2s_menu_permissions: [{role2: [{admin2s_role2s: :admin2}]}]).where(admin2s: {id: current_user.id})
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
#上传医生患者头像
  def uploadFileToAliyun(file)
    #if !file.original_filename.empty?
    #连接信息
    Aliyun::OSS::Base.establish_connection!(
        :server => Settings.aliyunOSS.beijing_service, #可不填,默认为此项
        :access_key_id => 'h17xgVZatOgQ6IeJ',
        :secret_access_key => '6RrQAXRaurcitBPzdQ18nrvEWjWuWO'
    )
    bucket = Settings.aliyunOSS.image_bucket
    mimas_dev_bucket = Bucket.find(bucket) #查找Bucket
    obj = mimas_dev_bucket.new_object #在此Bucket新建Object
    #生成一个随机的文件名 uuid+后缀类型的文件
    uuid = file
    obj.key = 'avatar/'+uuid
    # obj.key = file
    obj.value= open(file)
    ##向dir目录写入文件
    obj.store
    return uuid
  end
#上传富文本框中的图片
  def uplod_kineditor_img_to_aliyun(file)
    #连接信息
    Aliyun::OSS::Base.establish_connection!(
        :server => Settings.aliyunOSS.kindeditor_service, #可不填,默认为此项
        :access_key_id => 'h17xgVZatOgQ6IeJ',
        :secret_access_key => '6RrQAXRaurcitBPzdQ18nrvEWjWuWO'
    )
    bucket = Settings.aliyunOSS.kindeditor_bucket
    mimas_dev_bucket = Bucket.find(bucket) #查找Bucket
    obj = mimas_dev_bucket.new_object #在此Bucket新建Object
    #生成一个随机的文件名 uuid+后缀类型的文件
    obj.key = getFileName(file.original_filename)
    # obj.key = file
    obj.value= open(file)
    ##向dir目录写入文件
    obj.store
    return obj.key
  end

  def upload_video_img_bucket(file)
    if !file.original_filename.empty?
      Aliyun::OSS::Base.establish_connection!(
          :server => Settings.aliyunOSS.beijing_service, #可不填,默认为此项
          :access_key_id => 'h17xgVZatOgQ6IeJ',
          :secret_access_key => '6RrQAXRaurcitBPzdQ18nrvEWjWuWO'
      )
      video_image_bucket = Bucket.find(Settings.aliyunOSS.video_bucket) #查找Bucket
      obj = video_image_bucket.new_object #在此Bucket新建Object
      obj.key = getFileName(file.original_filename)
      #obj.key = file
      obj.value= open(file)
      obj.store
      return obj.key
    end
  end

  def uploadToAliyun(file,server,bucket)
    if !file.original_filename.empty?
      Aliyun::OSS::Base.establish_connection!(
          :server => server, #可不填,默认为此项
          :access_key_id => 'h17xgVZatOgQ6IeJ',
          :secret_access_key => '6RrQAXRaurcitBPzdQ18nrvEWjWuWO'
      )
      video_image_bucket = Bucket.find(bucket) #查找Bucket
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
    return filename
  end

  # delete object by filename
  #def delte_file_from_aliyun(file)
  #  Aliyun::OSS::Base.establish_connection!(
  #      :server => 'oss-cn-beijing.aliyuncs.com', #可不填,默认为此项
  #      :access_key_id => 'h17xgVZatOgQ6IeJ',
  #      :secret_access_key => '6RrQAXRaurcitBPzdQ18nrvEWjWuWO'
  #  )
  #  # mimas_open_bucket = Bucket.find(BUCKET) #查找Bucket
  #  begin
  #    OSSObject.delete(file, Settings.aliyunOSS.default_bucket) #删除文件
  #  rescue
  #    puts 'delte  error'
  #  end
  #end

  #删除视频文件
  def delte_video_file_from_aliyun(file)
    Aliyun::OSS::Base.establish_connection!(
        :server => 'oss-cn-beijing.aliyuncs.com', #可不填,默认为此项
        :access_key_id => 'h17xgVZatOgQ6IeJ',
        :secret_access_key => '6RrQAXRaurcitBPzdQ18nrvEWjWuWO'
    )
    # mimas_open_bucket = Bucket.find(BUCKET) #查找Bucket
    begin
      p file
      put 'success'
      OSSObject.delete(file, Settings.aliyunOSS.video_bucket) #删除文件
    rescue
      puts 'delte  error'
    end
  end

  def deleteFromAliyun(file,server,bucket)
      Aliyun::OSS::Base.establish_connection!(
          :server => server, #可不填,默认为此项
          :access_key_id => 'h17xgVZatOgQ6IeJ',
          :secret_access_key => '6RrQAXRaurcitBPzdQ18nrvEWjWuWO'
      )
  # mimas_open_bucket = Bucket.find(BUCKET) #查找Bucket
    begin
      p file
      OSSObject.delete(file, bucket) #删除文件
      p 'success'
    rescue
      puts 'delete  error'
    end
  end

  def pk_id_rules
    require 'securerandom'
    random=SecureRandom.random_number(9999)
    time=Time.now.to_i
    id=(time.to_s+random.to_s).to_i
    return id
  end

  # 判断文件或者图片时否存在
  # 参数bucket用于判断要在云存储的哪个bucket里面找
  def aliyun_file_exit(file_name, bucket)

    # 链接阿里云方法
    Aliyun::OSS::Base.establish_connection!(
        :server => Settings.aliyunOSS.beijing_service, #可不填,默认为此项
        :access_key_id => 'h17xgVZatOgQ6IeJ',
        :secret_access_key => '6RrQAXRaurcitBPzdQ18nrvEWjWuWO'
    )
    # @flag=OSSObject.exists? '00b3d574-e16f-400f-854a-d6ade58ec75e.png','mimas-img'
    @flag=OSSObject.exists? file_name, bucket
  end

end
