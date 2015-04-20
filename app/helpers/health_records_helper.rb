#encoding:utf-8
module HealthRecordsHelper

  #子类数据添加或者删除之后 需要相应的添加删除inspection_reports总表
  #InspectionUltrasound.create(patient_id: 114139562695684,parent_type: "影像数据", child_type: "超声",
  #                            thumbnail: "111111.xml", doctor: "盛林",
  #                            hospital: "清华大学玉泉医院", department: "超声科", upload_user_id: "222222222",
  #                            upload_user_name: "测试",checked_at: "2011-09-27")
  def create_inspection_report
    InspectionReport.create(patient_id: self.patient_id,parent_type: self.parent_type, child_type: self.child_type,
                            thumbnail: self.thumbnail,  identifier: self.identifier, doctor: self.doctor,
                            hospital: self.hospital, department: self.department, upload_user_id: self.upload_user_id,
                            upload_user_name: self.upload_user_name,checked_at: self.checked_at, child_id: self.id,
                            image_list: self.image_list, video_list: self.video_list, study_body: self.study_body
    )
    #@wus = WeixinUser.where("patient_id=?",self.patient_id)
    #if @wus.length>0
    #  @wu = @wus.first
    #  @weixin = WeixinUser.new
    #  access_token = @weixin.getAccessToken
    #  url = "#{Settings.weixin.redirect}/weixin_patient/health_record?patient_id=#{self.patient_id}"
    #  body = {
    #      "touser"=>@wu.openid,
    #      "msgtype"=>"news",
    #      "news"=>{
    #          "articles"=>[
    #              {
    #                  "title"=>"健康档案创建成功",
    #                  "description"=>"数据类型:    #{self.child_type}\n检查医院:    #{self.hospital}\n检查日期:    #{self.checked_at}",
    #                  "url"=>url,
    #                  "picurl"=>""
    #              }
    #          ]
    #      }
    #  }
    #  #先发送客服消息如果不成功 在发送模板消息
    #  res = @weixin.sendText(access_token, body)
    #  if res!="ok"
    #    body =  {
    #        "touser"=>@wu.openid,
    #        "template_id"=>"VcMs25u7E3zy3fg7xMcIaNEJToyvZLEjPhru3tze2b0",
    #        "url"=>url,
    #        "topcolor"=>"#000000",
    #        "data"=>{
    #            "first"=> {
    #                "value"=>"你好，您有新的健康档案已生成，详情如下",
    #                "color"=>"#000000"
    #            },
    #            "keyword1"=>{
    #                "value"=>self.child_type,
    #                "color"=>"#0243ba"
    #            },
    #            "keyword2"=> {
    #                "value"=>self.hospital,
    #                "color"=>"#0243ba"
    #            },
    #            "keyword3"=>{
    #                "value"=>self.checked_at,
    #                "color"=>"#0243ba"
    #            },
    #            "remark"=> {
    #                "value"=>"点击即可查看健康档案详情！",
    #                "color"=>"#000000"
    #            }
    #        }
    #    }
    #    @weixin.sendTmpText(access_token, body)
    #  end
    #end
  end

  def update_inspection_report
    @inspection_report=InspectionReport.where(parent_type: self.parent_type, child_type: self.child_type, child_id: self.id).first
    if !@inspection_report.nil?
      @inspection_report.update(patient_id: self.patient_id, parent_type: self.parent_type, child_type: self.child_type,
                                thumbnail: self.thumbnail, identifier: self.identifier, doctor: self.doctor,
                                hospital: self.hospital, department: self.department, upload_user_id: self.upload_user_id,
                                upload_user_name: self.upload_user_name, checked_at: self.checked_at, child_id: self.id,
                                image_list: self.image_list, video_list: self.video_list, study_body: self.study_body
      )
    end
  end

  def delete_inspection_report
    @inspection_report=InspectionReport.where(patient_id:self.patient_id,parent_type:self.parent_type,child_type: self.child_type,child_id:self.id).first
    if !@inspection_report.nil?
      @inspection_report.destroy
    end
    # TODO释放云端对应的资源

  end
end
