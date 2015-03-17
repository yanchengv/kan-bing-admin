include SessionsHelper
class Doctor < ActiveRecord::Base
  self.table_name = "doctors"
  self.inheritance_column = "ruby_type"
  before_create :set_pk_code,:pinyin,:set_default_value
  before_update :update_default_value,:after_update_do,:after_update_user
  before_destroy :destroy_patient
  after_create :save_patient
  has_one :user, :dependent => :destroy
  belongs_to :province2, class_name: "Province", :foreign_key => :province_id
  belongs_to :city
  belongs_to :hospital
  belongs_to :department
  has_many :doctor_friendships, foreign_key: :doctor1_id,:dependent => :destroy
  has_and_belongs_to_many :groups
  has_and_belongs_to_many :skills
  #has_many :doctors_groups, :dependent => :destroy
  #has_many :doctors_skills, :dependent => :destroy
  #has_many :groups, :through => :doctors_groups, :source => :group
  #has_many :skills, :through => :doctors_skills, :source => :skill
  has_many :doctor_friendships, foreign_key: :doctor2_id,:dependent => :destroy
  has_many :treatment_relationships, :dependent => :destroy
  has_many :patfriends, :through => :treatment_relationships, :source  => :patient
  has_many :consultations, foreign_key: "owner_id", dependent: :destroy
  has_many :cons_orders, foreign_key: "owner_id", dependent: :destroy
  has_many :appointments,:dependent => :destroy
  has_many :appointment_arranges,:dependent => :destroy
  has_many :appointment_schedules,:dependent => :destroy
  has_many :edu_videos,:dependent => :destroy
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
  #医生保存后，如果没有patient_id则需创建并添加
  def save_patient

    if self.patient_id.nil? || self.patient_id.blank? || self.patient_id == 0
      @patient = Patient.new(:name => self.name, :credential_type => self.credential_type, :credential_type_number => self.credential_type_number, :gender => self.gender,
                                :birthday => self.birthday, :birthplace => self.birthplace, :province_id => self.province_id, :city_id => self.city_id, :hospital_id => self.hospital_id,
                                :department_id => self.department_id, :address => self.address, :nationality => self.nationality, :citizenship => self.citizenship, :photo => self.photo,
                                :marriage => self.marriage, :mobile_phone => self.mobile_phone,:home_phone => self.home_phone, :home_address => self.home_address, :contact => self.contact,
                                :contact_phone => self.contact_phone,:home_postcode => self.home_postcode, :email => self.email, :introduction => self.introduction, :verify_code => self.verify_code,
                                :is_checked => self.is_checked, :is_activated => self.is_activated, :is_public => self.is_public, :spell_code => self.spell_code, :province => self.province_name, :organization_id => self.organization_id)
      if @patient.save
        @doctor = Doctor.where(:id => self.id).first
        @doctor.update_attributes(:patient_id => @patient.id)
      end
    end
  end
  def manage_doctors  (menu_name,admin_id)
    @menu=Menu.where(name:menu_name).first
    @hospitals=Hospital.find_by_sql("select h.id,h.name from hospitals h,role2s r, menu_permissions mp , admin2s_role2s ar,role2s_menu_permissions rmp, menus where  mp.id=rmp.menu_permission_id and ar.admin2_id=#{admin_id} and ar.role2_id=r.id and r.id=rmp.role2_id and menus.id=mp.menu_id and menus.parent_id=#{@menu.id} and mp.menu_id=menus.id and h.id=mp.hospital_id GROUP BY h.id;")
  end

  def after_update_do
    @doc_videos = self.edu_videos
    if !@doc_videos.empty?
      @doc_videos .each do |video|
        video.update_attributes(hospital_id:self.hospital_id,department_id:self.department_id)
      end
    end
  end

  def after_update_user    #医生修改信息时,同步修改相关用户信息
    @user = self.user
    if !@user.nil?
      @user.update_attributes(real_name:self.name,email:self.email,mobile_phone:self.mobile_phone,credential_type_number:self.credential_type_number)
    end
  end

  def destroy_patient
    @patient = Patient.where(id:self.patient_id)
    if !@patient.empty?
      @patient.each do |pat|
        pat.destroy
      end
    end
  end

end
