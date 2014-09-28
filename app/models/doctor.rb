include SessionsHelper
class Doctor < ActiveRecord::Base
  before_create :set_pk_code,:pinyin,:set_default_value
  before_update :update_default_value
  has_one :user, :dependent => :destroy
  belongs_to :province
  belongs_to :city
  belongs_to :hospital
  belongs_to :department
  def pinyin
    self.spell_code = PinYin.abbr(self.name)
  end

  def set_default_value
    if self.name
      self.name = name
    else
      self.name = id
    end
    if self.birthday
      self.birthday = birthday
    else
      self.birthday=Time.now
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
    if self.birthday
      self.birthday = birthday
    else
      self.birthday=Time.now
    end
  end

  def set_pk_code
    if self.id&&self.id!=0
      self.id = id
    else
      self.id = pk_id_rules
    end
  end

end
