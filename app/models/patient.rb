include SessionsHelper
class Patient < ActiveRecord::Base
  before_create :set_pk_code,:pinyin,:set_default_value, :auto_assign_doctor
  before_update :update_default_value ,:after_update_user
  after_update :update_doc2user
  belongs_to :province2, class_name: "Province", :foreign_key => :province_id
  belongs_to :city
  belongs_to :doctor
  belongs_to :hospital
  belongs_to :department
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
  #患者信息更新时对应的医生和用户信息也应更改.
  def update_doc2user
    @doctor = Doctor.where(:patient_id => self.id).first
    if @doctor
      @doctor.update_attributes(:name => self.name, :credential_type => self.credential_type, :credential_type_number => self.credential_type_number, :gender => self.gender,
                                :birthday => self.birthday, :birthplace => self.birthplace, :province_id => self.province_id, :city_id => self.city_id, :hospital_id => self.hospital_id,
                                :department_id => self.department_id, :address => self.address, :nationality => self.nationality, :citizenship => self.citizenship, :photo => self.photo,
                                :marriage => self.marriage, :mobile_phone => self.mobile_phone, :home_phone => self.home_phone, :home_address => self.home_address, :contact => self.contact,
                                :contact_phone => self.contact_phone, :home_postcode => self.home_postcode, :email => self.email, :introduction => self.introduction, :verify_code => self.verify_code,
                                :is_checked => self.is_checked, :is_activated => self.is_activated, :is_public => self.is_public, :spell_code => self.spell_code, :province_name => self.province, :organization_id => self.organization_id)

    end
    @user = User.where(:patient_id => self.id).first
    if @user
      @user.update_attributes(:real_name => self.name, :mobile_phone => self.mobile_phone, :email => self.email, :credential_type_number => self.credential_type_number)
    end
  end

end
