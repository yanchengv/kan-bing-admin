#encoding:utf-8
class HealthRecordsController < ApplicationController
  require 'open-uri'
  delegate "default_access_url_prefix_with", :to => "ActionController::Base.helpers"
  before_filter :signed_in_user
  skip_before_filter :verify_authenticity_token ,only:[:upload,:show_upload_dicom,:upload_dicom]
  layout "application2",only:[:index,:show_index,:dicom,:ct2,:mri2,:ultrasound2,:inspection_report2,:upload_dicom]
  #before_filter :user_health_record_power, only: [:ct,:ultrasound,:inspection_report]

  def index
    require "base64"
    session["patient_id"] = Base64.decode64 params[:id]
    # session["patient_id"]=params[:id]
    # render partial: 'health_records/records_manage'
  end

  def show_index
    @type = params[:type]
    @flag = params[:flag]
    @url_path = '/health_records/'+@type+"?flag=#{params[:flag]}"
    render partial: 'health_records/records_manage'
  end



  def show_upload_dicom
    @patient_id=session["patient_id"]
    render template: 'health_records/show_upload_dicom',layout:'application3'
  end

  #dicom上传
  def upload_dicom
    guid=params[:guid]
    patient_id=params[:patient_id]
    # patient_id=patient_id.gsub(" ","+")
    # patient_id=AES.decrypt(patient_id.to_s,Settings.key)  #aes解密
    guid2=SecureRandom.uuid
    upload_path = "uploads/dicom/"
    file_dir = Rails.root.join('public', upload_path)
    FileUtils.mkdir_p(file_dir)
    uploaded_io=params[:file]
    filename=params[:name]<<guid2
    File.open(Rails.root.join('public', upload_path,filename), 'wb') do |file|
      file.write (uploaded_io.read)
    end
    # 文件的本地路徑
    file_url="#{Rails.root}/public/uploads/dicom/#{filename}"

    @flag=InspectionCt.new.upload_to patient_id,file_url,nil
    if @flag==true
      # 上傳成功後刪除本地文件
      if File.exists?("#{Rails.root}/public/uploads/dicom/#{filename}")
        File.delete("#{Rails.root}/public/uploads/dicom/#{filename}")
      end
    else
      if File.exists?("#{Rails.root}/public/uploads/dicom/#{filename}")
        File.delete("#{Rails.root}/public/uploads/dicom/#{filename}")
      end
      @flag=false
    end

    render json:@flag
  end

  def play_video
    @video_url = Settings.aliyunOSS.image_url+params[:video_url]
    #url = params[:video_url].split('.')[0]
    #@video_url = Settings.edu_video + url[1,2] + '/' + url[4,2] + '/' + url[7,2] + '/' + url[10,30]
  end

  def go_where
    # require "aes"
    # key = '290c3c5d812a4ba7ce33adf09598a462'
    # params[:child_id] = AES.encrypt(params[:child_id].to_s,key)
    # if  !params[:uuid].nil? && !params[:child_type].nil?
    if !params[:child_type].nil?
      case params[:child_type]
        when 'CT'
          redirect_to :action => :ct, :child_id => params[:child_id],  :inspection_type => 'CT'
        when '超声'
          redirect_to :action => :ultrasound, :uuid => params[:uuid], :child_id => params[:child_id]
        when '检验报告'
          redirect_to :action => :inspection_report, :uuid => params[:uuid]
        when '核磁','MR'
          redirect_to :action => :mri, :child_id => params[:child_id], :inspection_type => 'MR'
        when '心电图'
          redirect_to '/ecg/show?ecg_id='+params[:uuid]
      end
    else
      redirect_to  root_path   :notice => "请求出现异常"
    end
  end

  def ct
    require "base64"
    params[:child_id] = Base64.decode64 params[:child_id]
    # require "aes"
    # key = '290c3c5d812a4ba7ce33adf09598a462'
    # params[:child_id] = params[:child_id].gsub(/[ ]/, '+')
    # params[:child_id] = AES.decrypt(params[:child_id].to_s,key)
    @obj ||= params[:child_id]
    @inspection_type = params[:inspection_type]
    render :template => 'health_records/ct', layout: "application3"
  end

  # 核磁
  def mri
    require "base64"
    params[:child_id] = Base64.decode64 params[:child_id]
    # require "aes"
    # key = '290c3c5d812a4ba7ce33adf09598a462'
    # params[:child_id] = params[:child_id].gsub(/[ ]/, '+')
    # params[:child_id] = AES.decrypt(params[:child_id].to_s,key)
    @obj ||= params[:child_id]
    @inspection_type = params[:inspection_type]
    render "health_records/mri", layout: "application3"
  end


  def ultrasound
    require "base64"
    params[:child_id] = Base64.decode64 params[:child_id]
    params[:uuid] = Base64.decode64 params[:uuid]
    # require "aes"
    # key = '290c3c5d812a4ba7ce33adf09598a462'
    # params[:child_id] = params[:child_id].gsub(/[ ]/, '+')
    # params[:child_id] = AES.decrypt(params[:child_id].to_s,key)
    @uuid = params[:uuid]
    @iu = InspectionUltrasound.find(params[:child_id])
    @pics = @iu.image_list.nil? ? nil : @iu.image_list.split(',')
    @videos = @iu.video_list.nil? ? nil : @iu.video_list.split(',')
    @flag=aliyun_file_exit(@uuid,'mimas-img')
    render "health_records/ultrasound", layout: "application3"

    #uuid = @uuid.split('.')[0]
    #@uuid = uuid+'.png'
    #@pic = []
    #is_more = true
    #num = 1
    #@uuidObj = Uuid.new
    #while is_more
    #  file_path = Settings.files_mount + 'png/' + @uuidObj.parse_uuid(uuid)+"_#{num}.png"
    #  if File.exist?(file_path)
    #    @pic << uuid+"_#{num}.png"
    #    num+=1
    #  else
    #    is_more = false
    #  end
    #end
    #@pics = @pic.join(',')
  end

  def inspection_report
    require "base64"
    params[:uuid] = Base64.decode64 params[:uuid]
    p params[:uuid]
    # params[:child_id] = Base64.decode64 params[:child_id]
    # require "aes"
    # key = '290c3c5d812a4ba7ce33adf09598a462'
    # params[:child_id] = params[:child_id].gsub(/[ ]/, '+')
    # params[:child_id] = AES.decrypt(params[:child_id].to_s,key)
    @uuid = params[:uuid]
    @uuid = @uuid.split('.')[0]+'.png'
    render "health_records/inspection_report", layout: "application3"
  end

  def get_video
    send_data data.read, type: "application/x-shockwave-flash", disposition: "inline", stream: "true"
  end




  def get_data
    patient_id = session["patient_id"]
    irs = InspectionReport.where("patient_id = ?", patient_id).length
    cts = InspectionCt.where("patient_id = ?", patient_id).length
    ults = InspectionUltrasound.where("patient_id = ?", patient_id).length
    nms = InspectionNuclearMagnetic.where("patient_id = ?", patient_id).length
    inds = InspectionData.where("patient_id = ?", patient_id).length
    ecg_num= Ecg.where("patient_id=?",patient_id).length
    slzb_num=ecg_num
    data = {
        "ct" => cts,
        "ult" => ults,
        "nm" => nms,
        "dicom" => cts+ults+nms,
        "ins_report" => inds,
        "ins" => inds,
        "all" => irs,
        "slzb_num"=>slzb_num,
        "ecg_num"=>ecg_num
    }
    render json: {data: data}
  end

  def dicom
    @total=0
    noOfRows = params[:rows]
    page = params[:page]
    sql="patient_id=#{session['patient_id']}"
    if params[:flag] == 'jy'
      sql << " and parent_type='检验'"
    end
    if params[:flag] == 'yx'
      sql << " and parent_type='影像数据'"
    end
    if params[:flag] == 'sl'
      sql << " and parent_type='生理指标'"
    end

    records = InspectionReport.select("count(id) as rows_count").where(sql)
    records = records[0].rows_count
    if !noOfRows.nil?
      if records%noOfRows.to_i == 0
        @total = records/noOfRows.to_i
      else
        @total = (records/noOfRows.to_i)+1
      end
    end
    if page.to_i>@total.to_i
      page = 1
    end
    @irs = InspectionReport.where(sql).order("checked_at DESC").limit(noOfRows.to_i).offset(noOfRows.to_i*(page.to_i-1))
    @objJSON = {total:@total,health_records:@irs,page:page,records:records}
    render :json => @objJSON.as_json
  end

  def ct2
    @total=0
    noOfRows = params[:rows]
    page = params[:page]
    records = InspectionCt.select("count(id) as rows_count").where("patient_id = ? and child_type='CT'", session["patient_id"])
    records = records[0].rows_count
    if !noOfRows.nil?
      if records%noOfRows.to_i == 0
        @total = records/noOfRows.to_i
      else
        @total = (records/noOfRows.to_i)+1
      end
    end
    if page.to_i>@total.to_i
      page = 1
    end
    @irs = InspectionCt.where("patient_id = ? and child_type='CT'",session["patient_id"]).order("checked_at DESC").limit(noOfRows.to_i).offset(noOfRows.to_i*(page.to_i-1))
    @objJSON = {total:@total,health_records:@irs,page:page,records:records}
    render :json => @objJSON.as_json
  end
   def mri2
     @total=0
     noOfRows = params[:rows]
     page = params[:page]
     records = InspectionCt.select("count(id) as rows_count").where("patient_id = ? and child_type='MR'", session["patient_id"])
     records = records[0].rows_count
     if !noOfRows.nil?
       if records%noOfRows.to_i == 0
         @total = records/noOfRows.to_i
       else
         @total = (records/noOfRows.to_i)+1
       end
     end
     if page.to_i>@total.to_i
       page = 1
     end
     @irs = InspectionCt.where("patient_id = ? and child_type='MR'",session["patient_id"]).order("checked_at DESC").limit(noOfRows.to_i).offset(noOfRows.to_i*(page.to_i-1))
     @objJSON = {total:@total,health_records:@irs,page:page,records:records}
     render :json => @objJSON.as_json
   end

  def ultrasound2
    @total=0
    noOfRows = params[:rows]
    page = params[:page]
    records = InspectionUltrasound.select("count(id) as rows_count").where("patient_id = ?", session["patient_id"])
    records = records[0].rows_count
    if !noOfRows.nil?
      if records%noOfRows.to_i == 0
        @total = records/noOfRows.to_i
      else
        @total = (records/noOfRows.to_i)+1
      end
    end
    if page.to_i>@total.to_i
      page = 1
    end
    @irs = InspectionUltrasound.where("patient_id = ?",session["patient_id"]).order("checked_at DESC").limit(noOfRows.to_i).offset(noOfRows.to_i*(page.to_i-1))
    @objJSON = {total:@total,health_records:@irs,page:page,records:records}
    render :json => @objJSON.as_json
  end

  def inspection_report2
    @total=0
    noOfRows = params[:rows]
    page = params[:page]
    records = InspectionData.select("count(id) as rows_count").where("patient_id = ?", session["patient_id"])
    records = records[0].rows_count
    if !noOfRows.nil?
      if records%noOfRows.to_i == 0
        @total = records/noOfRows.to_i
      else
        @total = (records/noOfRows.to_i)+1
      end
    end
    if page.to_i>@total.to_i
      page = 1
    end
    @irs = InspectionData. where("patient_id = ?",session["patient_id"]).order("checked_at DESC").limit(noOfRows.to_i).offset(noOfRows.to_i*(page.to_i-1))
    @objJSON = {total:@total,health_records:@irs,page:page,records:records}
    render :json => @objJSON.as_json
  end

  def ecg2
    @total=0
    noOfRows = params[:rows]
    page = params[:page]
    sql="patient_id=#{session['patient_id']} and child_type='心电图'"
    # records = Ecg.select("count(id) as rows_count").where(sql)
    records = InspectionReport.select("count(id) as rows_count").where(sql)
    records = records[0].rows_count
    if !noOfRows.nil?
      if records%noOfRows.to_i == 0
        @total = records/noOfRows.to_i
      else
        @total = (records/noOfRows.to_i)+1
      end
    end
    if page.to_i>@total.to_i
      page = 1
    end
    # @irs = Ecg.where(sql).order("measure_time DESC").limit(noOfRows.to_i).offset(noOfRows.to_i*(page.to_i-1))
    @irs = InspectionReport.where(sql).order("checked_at DESC").limit(noOfRows.to_i).offset(noOfRows.to_i*(page.to_i-1))
    @objJSON = {total:@total,health_records:@irs,page:page,records:records}
    render :json => @objJSON.as_json
  end

  # def undefined_other
  #   render partial: 'health_records/undefined_other'
  # end

  def upload
    b = false
    archive_type = params[:archivetype]
    stamp = DateTime.parse(Time.now.to_s).strftime("%T")
    upload_path = "uploads/cts/" << Date.today.to_s
    target_dir = Rails.root.join('public', upload_path)
    FileUtils.mkdir_p(target_dir)

    if !params[:fileToUpload].nil?
      if current_user.patient_id.nil?  && (!current_user.doctor_id.nil?)
        pat_id = params[:id]
        udoctor = current_user.doctor
      elsif !current_user.patient_id.nil? &&(current_user.doctor_id.nil?)
        pat_id = current_user.patient_id
        udoctor = current_user.patient.doctor
      end
      if !udoctor.nil?
        if !udoctor.hospital.nil?
          hospital_id = udoctor.hospital.id
          hospital_name = udoctor.hospital.name
        end

        if !udoctor.department.nil?
          department_id = udoctor.department.id
          department_name = udoctor.department.name
        end
        doctor_id = udoctor.id
        doctor_name = udoctor.name
      else
        hospital_id = ''
        hospital_name = ''
        department_id = ''
        department_name = ''
        doctor_id = ''
        doctor_name = ''
      end
      patient_name =  Patient.exists?(pat_id)?  Patient.find(pat_id).name: "unknownpatient"
      uploaded_io = params[:fileToUpload]
      filename1 = uploaded_io.original_filename
      filename = stamp << "-" << patient_name << "-" << filename1
      begin
        File.open(Rails.root.join('public', upload_path, filename), 'wb') do |file|
          file.write(uploaded_io.read)
          b = true
        end

        ArchiveQueue.create(
            :upload_user_id => current_user.id,
            :upload_user_name => current_user.name,
            :parent_type => "超声影像",
            :child_type => archive_type,
            :filename => upload_path << "/"<< filename,
            :filesize => uploaded_io.size,
            :extname => File.extname(filename1),
            :hospital_id => hospital_id,
            :hospital_name => hospital_name,
            :department_id => hospital_id,
            :department_name => department_name,
            :doctor_id => doctor_id,
            :doctor_name => doctor_name,
            :patient_id => pat_id,
            :patient_name => patient_name,
            :status => 1)
      rescue StandardError => e
        puts e
      ensure
        tempfile = uploaded_io.tempfile.path
        #p  "tmp file path is :"  <<  tempfile << "file exits? " << File.exists?(tempfile).to_s
        if File.exists?(tempfile)
          File.delete(tempfile)
        end
      end

    end

    if b
      render :text => ({:error => "",:msg => "文件上传成功,后台正在处理中请耐心等待处理结果"}.to_json)
    else
      render :text => ({:error => "true", msg: "文件类型错误或者存在异常"}.to_json)
    end

  end

  #添加健康档案界面
  def health_record_new
    if  !params[:type].nil? && !params[:type].nil?
      case params[:type]
        #when 'CT'
        #  render :partial => ''
        when '超声'
          render :partial => 'health_records/ultrasound_new_form'
        #when '检验报告'
        #  render :partial => ''
        #when '核磁', 'MR'
        #  render :partial => ''
        #when 'MR'
        #  render :partial => ''
        #when '心电图'
        #  render :partial => ''
      end
    else
      redirect_to root_path :notice => "请求出现异常"
    end
  end

  def health_record_edit
    if  !params[:type].nil? && !params[:type].nil?
      case params[:type]
        #when 'CT'
        #  render :partial => ''
        when '超声'
          @ultrasound = InspectionUltrasound.find(params[:id])
          render :partial => 'health_records/ultrasound_edit_form'
        #when '检验报告'
        #  render :partial => ''
        #when '核磁', 'MR'
        #  render :partial => ''
        #when 'MR'
        #  render :partial => ''
        #when '心电图'
        #  render :partial => ''
      end
    else
      redirect_to root_path :notice => "请求出现异常"
    end
  end

  def ultrasound_save
    @ultrasound = InspectionUltrasound.new(patient_id: params['patient_id'],
        patient_name: params['patient_name'],
        apply_department_name: params['apply_department_name'],
        us_order_id: params['us_order_id'],
        bed_no: params['bed_no'],
        apply_doctor_name: params['apply_doctor_name'],
        examined_item_name: params['examined_item_name'],
        examine_doctor_name: params['examine_doctor_name'],
        us_finding: params['us_finding'],
        us_diagnose: params['us_diagnose'],
        inputer_name: params['inputer_name'],
        image_list: params['image_list'],
        video_list: params['video_list'],
        # clinic_no: params['clinic_no'],
        us_order_id: params['hospitalized_no'],
        parent_type: '影像数据',
        child_type: '超声')
    if @ultrasound.save
      render :json => {:success => true}
    else
      render :json => {:success => false}
    end
  end

  def ultrasound_update
    if !params[:child_type].nil? && !params[:child_type].nil?
      case params[:child_type]
        #when 'CT'
        #  render :partial => ''
        when '超声'
          @ultrasound = InspectionUltrasound.find(params[:id])
          if !@ultrasound.image_list.nil? && !@ultrasound.image_list.blank?
            if !params['image_list'].nil? && !params['image_list'].blank?
              image_list = @ultrasound.image_list + ",#{params['image_list']}"
            else
              image_list = @ultrasound.image_list
            end
          else
            image_list = @ultrasound.image_list
          end
          if !@ultrasound.video_list.nil? && !@ultrasound.video_list.blank?
            if !params['video_list'].nil? && !params['video_list'].blank?
              video_list = @ultrasound.video_list + ",#{params['video_list']}"
            else
              video_list = @ultrasound.video_list
            end
          else
            video_list = @ultrasound.video_list
          end
          if @ultrasound.update_attributes(apply_department_name: params['apply_department_name'],
                                        bed_no: params['bed_no'],
                                        apply_doctor_name: params['apply_doctor_name'],
                                        examined_item_name: params['examined_item_name'],
                                        examine_doctor_name: params['examine_doctor_name'],
                                        image_list: image_list,
                                        video_list: video_list,
                                        clinic_no: params['clinic_no'],
                                        us_order_id: params['hospitalized_no'],
                                        us_finding: params['us_finding'],
                                        us_diagnose: params['us_diagnose'],
                                        inputer_name: params['inputer_name'])
            render :json => {:success => true}
          else
            render :json => {:success => false}
          end

        #when '检验报告'

        #when '核磁', 'MR'

        #when 'MR'

        #when '心电图'

      end
    else
      redirect_to root_path :notice => "请求出现异常"
    end
  end

  # 删除健康档案信息
  def ultrasound_delete
    if params[:child_type]=='DICOM'
      @inspection_report = InspectionReport.where(id:params[:child_id]).first
      if !@inspection_report.nil?
        child_id = @inspection_report.child_id
        child_type = @inspection_report.child_type
      end
    else
      child_id = params[:child_id]
      child_type = params[:child_type]
    end
    flag = false
    if child_type=='CT' || child_type=='MR'
      @inspection_ct = InspectionCt.where(id:child_id).first
      if !@inspection_ct.nil?
        study_body = @inspection_ct.study_body
        if !study_body.nil?
          body_arr = study_body.split(";")
          if !body_arr.empty?
            body_arr.each do |body|
              index = body.index(":")
              serie = body[0..index-1]
              instances_list = body[index+1..-1]
              instances_arr = instances_list.split(",")
              instances_arr.each do |instance|
                object_name = @inspection_ct.thumbnail+"/"+serie+"/"+instance
                if aliyun_file_exit(object_name,Settings.aliyunOSS.pacs_bucket)
                  deleteFromAliyun(object_name,Settings.aliyunOSS.beijing_service,Settings.aliyunOSS.pacs_bucket)
                end
              end
            end
          end
        end
        if @inspection_ct.destroy
          flag = true
        end
      end
    end
    if child_type=='超声'
      @ultrasound = InspectionUltrasound.where(id:child_id).first
      if !@ultrasound.nil?
        if !@ultrasound.image_list.nil?
          image_lists = @ultrasound.image_list.split(",")
          if !image_lists.empty?
            image_lists.each do |img|
              if aliyun_file_exit(img,Settings.aliyunOSS.image_bucket)
                deleteFromAliyun(img,Settings.aliyunOSS.beijing_service,Settings.aliyunOSS.image_bucket)
              end
            end
          end
        end
        if !@ultrasound.video_list.nil?
          video_lists = @ultrasound.video_list.split(",")
          if !video_lists.empty?
            video_lists.each do |video|
              if aliyun_file_exit(video,Settings.aliyunOSS.video_bucket)
                deleteFromAliyun(video,Settings.aliyunOSS.beijing_service,Settings.aliyunOSS.video_bucket)
              end
            end
          end
        end
        if @ultrasound.destroy
          flag = true
        end
      end
    end
    if child_type=='心电图'
      @ecg = Ecg.where(id:child_id).first
      if !@ecg.nil?
        if @ecg.destroy
          flag = true
        end
      end

    end
    if child_type=='检查报告'
      @inspection_data = InspectionData.where(id:child_id).first
      if !@inspection_data.nil?
        if !@inspection_data.thumbnail.nil? && aliyun_file_exit(@inspection_data.thumbnail,Settings.aliyunOSS.image_bucket)
          deleteFromAliyun(@inspection_data.thumbnail,Settings.aliyunOSS.beijing_service,Settings.aliyunOSS.image_bucket)
        end
        if @inspection_data.destroy
          flag = true
        end
      end
    end
    render json:{success:flag}
  end

  private
  #判断有无权限读取某一患者的超声报告
  def user_health_record_power
    @ips = InspectionReport.where('thumbnail=?',params[:uuid])
    is_equal = false
    unless @ips.empty?
      @ip = @ips.first
      if !current_user.patient_id.nil?
        is_equal = true if current_user.patient_id == @ip.patient_id
      else !current_user.doctor_id.nil?
        is_equal = true if (!Patient.where('id=? and doctor_id=?',@ip.patient_id,current_user.doctor_id).empty? || !TreatmentRelationship.where('doctor_id=? and patient_id=?',current_user.doctor_id,@ip.patient_id).empty?)
      end
    end
    redirect_to '/' unless is_equal
  end
end
