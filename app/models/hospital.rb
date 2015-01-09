include SessionsHelper
class Hospital < ActiveRecord::Base
  belongs_to :province
  belongs_to :city
  before_save :init_msg
  before_create :set_pk_code
  has_many :domains
  has_many :doctors, dependent: :destroy
  has_many :departments, dependent: :destroy

  after_update :updatedocs

  #更新该医院下的相关医生对应的信息
  def updatedocs
     docs = Doctor.where(:hospital_id => self.id )
     if  docs.count > 0
       if !self.name.empty?
         docs.update_all(:hospital_name => self.name)
       end

       if !self.province_id.empty?
         docs.update_all(:province_id => self.province_id)
       end

       if !self.province_name.empty?
         docs.update_all(:province_name => self.province_name)
       end

       if !self.city_id.empty?
         docs.update_all(:city_id => self.city_id)
       end

       if !self.city_name.empty?
         docs.update_all(:city_name => self.city_name)
       end
     end
  end

  def init_msg
    self.spell_code = PinYin.abbr(self.name)
    self.province_name = Province.find(self.province_id).name if self.province_id && self.province_id != ''
    self.city_name = City.find(self.city_id).name if self.city_id && self.city_id != ''
  end

  def set_pk_code
    if self.id&&self.id!=0
      self.id = id
    else
      self.id = pk_id_rules
    end
  end


end
