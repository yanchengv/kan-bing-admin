#encoding:utf-8
require 'json'
class WeixinUser < ActiveRecord::Base
  #attr_accessible :id, :openid, :patient_id, :doctor_id, :created_at, :updated_at

  def send_message_to_weixin(type,id,message='您好')
    @wxus = (type=='patient') ? WeixinUser.where('patient_id=?',id) : WeixinUser.where('doctor_id=?',id)
    res = 'false'
    if @wxus.size != 0
      openid = @wxus.first.openid
      #url = 'https://api.weixin.qq.com/cgi-bin/token?grant_type=client_credential&appid=wx814c2d89e8970870&secret=751cdb39cb83f3f387d06bde23159897'
      url = Settings.weixin.access_token + 'appid=' + Settings.weixin.app_id + '&secret=' + Settings.weixin.app_secret
      uri = URI.parse(url)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      request = Net::HTTP::Get.new(uri.request_uri)
      response = http.request(request)
      @data = JSON.parse response.body
      access_token = @data["access_token"]
      #url = 'https://api.weixin.qq.com/cgi-bin/message/custom/send?access_token='+access_token
      uri = URI.parse(Settings.weixin.send_message + access_token)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      req = Net::HTTP::Post.new(uri.request_uri)
      body = {
          touser: openid,
          msgtype: "text",
          text: {
              content: message
          }
      }
      req.body = body.to_json
      response = http.request(req)
      res = (JSON.parse response.body)["errmsg"]
    end
    res

  end

  def sendByOpenId(openid,message='您好')
    url = Settings.weixin.access_token + 'appid=' + Settings.weixin.app_id + '&secret=' + Settings.weixin.app_secret
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Get.new(uri.request_uri)
    response = http.request(request)
    @data = JSON.parse response.body
    access_token = @data["access_token"]
    #url = 'https://api.weixin.qq.com/cgi-bin/message/custom/send?access_token='+access_token
    uri = URI.parse(Settings.weixin.send_message + access_token)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    req = Net::HTTP::Post.new(uri.request_uri)
    body = {
        touser: openid,
        msgtype: "text",
        text: {
            content: message
        }
    }
    req.body = body.to_json
    response = http.request(req)
    res = (JSON.parse response.body)["errmsg"]
  end
end
