#encoding: utf-8
include SessionsHelper
class User < ActiveRecord::Base
   before_create :set_pk_code
  belongs_to :doctor, :foreign_key => :doctor_id
  belongs_to :patient, :foreign_key => :patient_id
   validates :name, presence: true, uniqueness: {case_sensitive: true, message: "该用户名已被使用！"}
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
end