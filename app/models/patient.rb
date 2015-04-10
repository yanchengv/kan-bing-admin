include SessionsHelper
class Patient < ActiveRecord::Base
  before_create :set_pk_code,:pinyin,:set_default_value, :auto_assign_doctor
  before_update :update_default_value ,:after_update_user
  after_destroy :delete_weixin2user
  belongs_to :province2, class_name: "Province", :foreign_key => :province_id
  belongs_to :city
  belongs_to :doctor
  belongs_to :hospital
  belongs_to :department
  belongs_to :organization
  # has_one :doctor_info, :class_name => 'Doctor', :dependent => :destroy
  has_one :user, :dependent => :destroy
  has_many :treatment_relationships, :dependent => :destroy
  has_many :docfriends, :through => :treatment_relationships, :source => :doctor
  has_many :appointmentblacklists, :dependent => :destroy
  has_many :appointments, :dependent => :destroy
  has_many :consultations, :dependent => :destroy
  has_many :blood_glucoses, :dependent => :destroy
  has_many :blood_pressures, :dependent => :destroy
  has_many :blood_fats, :dependent => :destroy
  has_many :blood_oxygens, :dependent =>:destroy
  has_many :weights, :dependent => :destroy
  has_many :us_reports,:dependent => :destroy
  has_many :inspection_reports,:dependent => :destroy


  def pinyin
    self.spell_code = PinYin.abbr(self.name)
  end

  def set_default_value
    if self.name
      self.name = name
    else
      self.name = id
    end
    self.is_checked = 0
    self.is_activated = 0
  end

  def update_default_value
    if self.name
      self.name = name
    else
      self.name = id
    end
  end

  def set_pk_code
    if self.id&&self.id!=0
      self.id = id
    else
      self.id = pk_id_rules
    end
  end

  def manage_patients (menu_name,admin_id)
    @menu=Menu.where(name:menu_name).first
    @hospitals=Hospital.find_by_sql("select h.id,h.name from hospitals h,role2s r, menu_permissions mp , admin2s_role2s ar,role2s_menu_permissions rmp, menus where  mp.id=rmp.menu_permission_id and ar.admin2_id=#{admin_id} and ar.role2_id=r.id and r.id=rmp.role2_id and menus.id=mp.menu_id and menus.parent_id=#{@menu.id} and mp.menu_id=menus.id and h.id=mp.hospital_id GROUP BY h.id;")
  end

  #创建患者后自动分配医生(医生助手)
  def auto_assign_doctor
    unless !self.doctor_id.nil? && self.doctor_id != ''
      @doctors = Doctor.where(:doctor_type => 'aide_doctor', :is_public => true).shuffle
      if !@doctors.nil? && !@doctors.empty?
        self.doctor_id = @doctors.first.id
      end
    end
  end

  def after_update_user    #患者修改信息时,同步修改相关用户信息
    @user = self.user
    if !@user.nil?
      @user.update_attributes(real_name:self.name,email:self.email,mobile_phone:self.mobile_phone,credential_type_number:self.credential_type_number)
    end
  end

  #当删除患者时,要同时删除对应的user 和 weixin用户
  def delete_weixin2user
    if self.id
      @users = User.where(:patient_id => self.id)
      if !@users.empty?
        @users.delete_all
      end
      @weixin_users = WeixinUser.where(:patient_id => self.id)
      if !@weixin_users.empty?
        @weixin_users.delete_all
      end
    end
  end

end
