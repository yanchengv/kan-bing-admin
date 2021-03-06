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
    if session[:expires_at].nil?
      session[:expires_at]=Time.now
    end
    @time_left = (session[:expires_at].to_time - Time.now.to_time).to_i
    unless @time_left > 0
      # reset_session
      sign_out
      redirect_to  '/sessions/sign_in'
      # render partial: 'sessions/sign_prompt'
    end
  end

  def session_expiry_root
    if session[:expires_at].nil?
      session[:expires_at]=Time.now
    end
    @time_left = (session[:expires_at].to_time - Time.now.to_time).to_i
    unless @time_left > 0
      # reset_session
      sign_out
      redirect_to  '/sessions/sign_in'
    end
    update_activity_time
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
      OSSObject.delete(file, bucket) #删除文件
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

  def all_menus
    require "aes"
    # key = AES.key
    key = '290c3c5d812a4ba7ce33adf09598a462'
    # params[:pId] = AES.decrypt(params[:pId], key)
    @menus=current_user.admin2_menus
    admin_id=current_user.id
    if current_user.admin_type == '医院管理员'
      @first_menus=Menu.find_by_sql("select menus.id,menus.parent_id as pId,menus.name,menus.uri,menus.icon from menus where menus.hos_admin_show=true and parent_id is null")
      if (params[:pId].nil? || params[:pId] == '') && !@first_menus.empty?
        # params[:pId] = @first_menus.first.id
        params[:pId] = AES.encrypt(@first_menus.first.id.to_s,key)
      end
      if @first_menus.empty?
        @left_menus = nil
      else
        params[:pId] = params[:pId].gsub(/[ ]/, '+')
        # params[:pId] = Base64.decode64 params[:pId].to_s
        params[:pId] = AES.decrypt(params[:pId].to_s,key)
        @left_menus = Menu.find_by_sql("select menus.id,menus.parent_id as pId,menus.name,menus.uri,menus.icon from menus where menus.hos_admin_show=true and parent_id=#{params[:pId]}")
        if @left_menus.empty?
          @left_menus = Menu.where(id:params[:pId])
        end
      end
      # @left_menus=[{name: "医生管理", uri: "/doctors"},{name: "患者管理", uri: "/patients"},{name: "用户管理", uri: "/users"},{name: "管理员管理", uri: "/admin2s"},{name: "医院管理", uri: "/hospitals"},{name: "教育视频管理", uri: "/edu_videos"},{name:"留言管理",uri:"/consult_accuses"},{name:"首页管理",uri:"",children:[{name:"首界面管理",uri:"/page_blocks/page_blocks_setting"},{name:"首界面区块管理",uri:"/page_blocks"},{name:"域名管理",uri:"/domain/show"}]}]
    elsif current_user.admin_type == '科室管理员'
      @first_menus=Menu.find_by_sql("select menus.id,menus.parent_id as pId,menus.name,menus.uri,menus.icon from menus where menus.dep_admin_show=true and parent_id is null")
      if (params[:pId].nil? || params[:pId] == '') && !@first_menus.empty?
        # params[:pId] = @first_menus.first.id
        params[:pId] = AES.encrypt(@first_menus.first.id.to_s,key)
      end
      if @first_menus.empty?
        @left_menus = nil
      else
        params[:pId] = params[:pId].gsub(/[ ]/, '+')
        # params[:pId] = Base64.decode64 params[:pId].to_s
        params[:pId] = AES.decrypt(params[:pId].to_s,key)
        @left_menus = Menu.find_by_sql("select menus.id,menus.parent_id as pId,menus.name,menus.uri,menus.icon from menus where menus.dep_admin_show=true and parent_id=#{params[:pId]}")
        if @left_menus.empty?
          @left_menus = Menu.where(id:params[:pId])
        end
      end
      # @left_menus=[{name: "医生管理", uri: "/doctors"},{name: "患者管理", uri: "/patients"},{name: "用户管理", uri: "/users"},{name: "教育视频管理", uri: "/edu_videos"},{name:"留言管理",uri:"/consult_accuses"},{name:"首页管理",uri:"",children:[{name:"首界面管理",uri:"/page_blocks/page_blocks_setting"},{name:"首界面区块管理",uri:"/page_blocks"},{name:"域名管理",uri:"/domain/show"}]}]
    elsif current_user.admin_type == '机构管理员'
      @first_menus=Menu.find_by_sql("select menus.id,menus.parent_id as pId,menus.name,menus.uri,menus.icon from menus where menus.ins_admin_show=true and parent_id is null")
      if (params[:pId].nil? || params[:pId] == '') && !@first_menus.empty?
        # params[:pId] = @first_menus.first.id
        params[:pId] = AES.encrypt(@first_menus.first.id.to_s,key)
      end
      if @first_menus.empty?
        @left_menus = nil
      else
        params[:pId] = params[:pId].gsub(/[ ]/, '+')
        # params[:pId] = Base64.decode64 params[:pId].to_s
        params[:pId] = AES.decrypt(params[:pId].to_s,key)
        @left_menus = Menu.find_by_sql("select menus.id,menus.parent_id as pId,menus.name,menus.uri,menus.icon from menus where menus.ins_admin_show=true and menus.parent_id=#{params[:pId]}")
        if @left_menus.empty?
          @left_menus = Menu.where(id:params[:pId])
        end
      end
    else
      @first_menus=Menu.find_by_sql("select menus.id,menus.parent_id as pId,menus.name,menus.uri,menus.icon from role2s r, role2_menus rm, admin2s_role2s ar, menus where rm.role2_id=ar.role2_id and rm.menu_id=menus.id and ar.admin2_id=#{admin_id} and menus.parent_id is null GROUP BY menus.id;")
      if (params[:pId].nil? || params[:pId] == '') && !@first_menus.empty?
        params[:pId] = AES.encrypt(@first_menus.first.id.to_s,key)
      end
      if @first_menus.empty?
        @left_menus = nil
      else
        params[:pId] = params[:pId].gsub(/[ ]/, '+')
        # params[:pId] = Base64.decode64 params[:pId].to_s
        params[:pId] = AES.decrypt(params[:pId].to_s,key)
        @left_menus = Menu.find_by_sql("select menus.id,menus.parent_id as pId,menus.name,menus.uri,menus.icon from role2s r, role2_menus rm, admin2s_role2s ar, menus where rm.role2_id=ar.role2_id and rm.menu_id=menus.id and ar.admin2_id=#{admin_id} and menus.parent_id=#{params[:pId]} GROUP BY menus.id;")
        if @left_menus.empty?
          @left_menus = Menu.where(id:params[:pId])
        end
      end
      # @first_menus=Menu.new.left_menu admin_id
    end
  end

end
