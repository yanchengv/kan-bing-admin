#encoding: utf-8
include SessionsHelper
class User < ActiveRecord::Base
   before_create :set_pk_code
  belongs_to :doctor, :foreign_key => :doctor_id
  belongs_to :patient, :foreign_key => :patient_id
  # validates :name, presence: true, uniqueness: {case_sensitive: true, message: "该用户名已被使用！"}
   attr_reader :password
   has_secure_password :validations => false
  #获取登录用户收到的文章分享
   def set_pk_code
     if self.id&&self.id!=0
       self.id = id
     else
       self.id = pk_id_rules
     end
   end

   #上传文件生成uuid
   def uuid(suffix)
     uuid = UUIDTools::UUID.random_create.to_s
     uuid = uuid.gsub('-','')+suffix
     #uuid = uuid[1,2]+'/'+uuid[4,2]+'/'+uuid[7,2]+'/'+uuid[10,100]
   end
   #生成上传文件的目录
   def create_folder_by_uuid(uuid)
     folder='/dfs/jpg/'
     if !File.exist?(folder)
       Dir.mkdir(folder)
     end
     folder_2 = "#{folder}"+uuid[1,2]+"/"
     if !File.exist?(folder_2)
       Dir.mkdir(folder_2)
     end
     folder_3 = "#{folder_2}"+uuid[4,2]+"/"
     if !File.exist?(folder_3)
       Dir.mkdir(folder_3)
     end
     folder_4 = "#{folder_3}"+uuid[7,2]+"/"
     if !File.exist?(folder_4)
       Dir.mkdir(folder_4)
     end
     #image_path=/dfs/6f/c7/dc/bd4e17bad466d6f1a5b2f9.jpg
     image_path = folder_4+uuid[10,100]
     image_path
   end
  #检查用户名,证件号,手机号,邮箱是否重复
  def check_obj(user_params)
    str = ''
    user = User.new(user_params)
    if !user.name.nil? && user.name != ''
      if !user.id.nil? && user.id != '' && user.id != 0
        @user_ns = User.where("id != ? and name = ?", user.id, user.name)
      else
        @user_ns = User.where(:name => user.name)
      end
    end
    if !user.mobile_phone.nil? && user.mobile_phone != ''
      if !user.id.nil? && user.id != '' && user.id != 0
        @user_mps = User.where("id != ? and mobile_phone = ?", user.id, user.mobile_phone)
      else
        @user_mps = User.where(:mobile_phone => user.mobile_phone)
      end
    end
    if !user.verification_code.nil? && user.verification_code != ''
      if !user.id.nil? && user.id != '' && user.id != 0
        @user_ctns = User.where("id != ? and verification_code = ?", user.id, user.verification_code)
      else
        @user_ctns = User.where(:verification_code => user.verification_code)
      end
    end
    if !user.email.nil? && user.email != ''
      if !user.id.nil? && user.id != '' && user.id != 0
        @user_es = User.where("id != ? and email = ?", user.id, user.email)
      else
        @user_es = User.where(:email => user.email)
      end
    end

    if !@user_ns.nil? && !@user_ns.empty?
      str += '用户名、'
    end
    if !@user_mps.nil? && !@user_mps.empty?
      str += '手机号、'
    end
    if !@user_ctns.nil? && !@user_ctns.empty?
      str += '证件号、'
    end
    if !@user_es.nil? && !@user_es.empty?
      str += '邮箱、'
    end
    if str == ''
      return 'ok'
    else
      return str[0, str.length-1] + '不能重复!'
    end
  end
end