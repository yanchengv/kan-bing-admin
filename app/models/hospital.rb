include SessionsHelper
class Hospital < ActiveRecord::Base
  belongs_to :province
  belongs_to :city
  before_save :init_msg
  before_create :set_pk_code
  has_many :domains
  has_many :doctors, dependent: :destroy
  has_many :departments, dependent: :destroy
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
