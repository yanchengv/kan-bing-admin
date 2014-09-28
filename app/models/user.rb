#encoding: utf-8
include SessionsHelper
class User< ActiveRecord::Base
  # before_create :create_remember_token ,:set_pk_code
  belongs_to :doctor, :foreign_key => :doctor_id
  belongs_to :patient, :foreign_key => :patient_id
  #获取登录用户收到的文章分享
end