#encoding:utf-8
class HealthRecordsController < ApplicationController
  require 'open-uri'
  delegate "default_access_url_prefix_with", :to => "ActionController::Base.helpers"
  before_filter :signed_in_user
  skip_before_filter :verify_authenticity_token ,only:[:upload]
  layout "application2",only:[:index,:show_index,:dicom,:ct2,:mri2,:ultrasound2,:inspection_report2]
  #before_filter :user_health_record_power, only: [:ct,:ultrasound,:inspection_report]

  def index
    session["patient_id"]=params[:id]
    # render partial: 'health_records/records_manage'
  end

  def show_index
    type = params[:type]
    @url_path = '/health_records/'+type
    render partial: 'health_records/records_manage'
  end

  def play_video
    @video_url = Settings.aliyunOSS.image_url+params[:video_url]
    #url = params[:video_url].split('.')[0]
    #@video_url = Settings.edu_video + url[1,2] + '/' + url[4,2] + '/' + url[7,2] + '/' + url[10,30]
  end

  def go_where
    if  !params[:uuid].nil? && !params[:child_type].nil?
      case params[:child_type]
        when 'CT'
          redirect_to "/health_records/ct?child_id=#{params[:child_id]}&inspection_type=CT"
          #redirect_to '/health_records/ct?uuid='+params[:uuid]
        when '超声'
            redirect_to "/health_records/ultrasound?uuid=#{params[:uuid]}&child_id=#{params[:child_id]}"
        when '检验报告'
          redirect_to '/health_records/inspection_report?uuid='+params[:uuid]
        when '核磁','MR'
          redirect_to "/health_records/mri?child_id=#{params[:child_id]}&inspection_type=MR"
          #redirect_to '/health_records/mri?uuid='+params[:uuid]
        when '心电图'
          redirect_to '/ecg/show?ecg_id='+params[:uuid]
      end
    else
      redirect_to  root_path   :notice => "请求出现异常"
    end
  end

  def ct
    @obj ||= params[:child_id]
    @inspection_type = params[:inspection_type]
    #@obj ||= params[:uuid]
  end

  # 核磁
  def mri
    @obj ||= params[:child_id]
    @inspection_type = params[:inspection_type]
    #@obj ||= params[:uuid]
  end


  def ultrasound
    @uuid = params[:uuid]
    @iu = InspectionUltrasound.find(params[:child_id])
    @pics = @iu.image_list.split(',')
    @videos = @iu.video_list.split(',')
    @flag=aliyun_file_exit(@uuid,'mimas-img')

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
    @uuid = params[:uuid]
    @uuid = @uuid.split('.')[0]+'.png'
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
    records = InspectionReport.select("count(id) as rows_count").where("patient_id = ?", session["patient_id"])
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
    @irs = InspectionReport.where("patient_id = ?", session["patient_id"]).order("checked_at DESC").limit(noOfRows.to_i).offset(noOfRows.to_i*(page.to_i-1))
    @objJSON = {total:@total,health_records:@irs,page:page,records:records}
    render :json => @objJSON.as_json
  end

  def ct2
    @total=0
    noOfRows = params[:rows]
    page = params[:page]
    records = InspectionCt.select("count(id) as rows_count").where("patient_id = ?", session["patient_id"])
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
    @irs = InspectionCt.where("patient_id = ?",session["patient_id"]).order("checked_at DESC").limit(noOfRows.to_i).offset(noOfRows.to_i*(page.to_i-1))
    @objJSON = {total:@total,health_records:@irs,page:page,records:records}
    render :json => @objJSON.as_json
  end
   def mri2
     @total=0
     noOfRows = params[:rows]
     page = params[:page]
     records = InspectionNuclearMagnetic.select("count(id) as rows_count").where("patient_id = ?", session["patient_id"])
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
     @irs = InspectionNuclearMagnetic.where("patient_id = ?",session["patient_id"]).order("checked_at DESC").limit(noOfRows.to_i).offset(noOfRows.to_i*(page.to_i-1))
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
