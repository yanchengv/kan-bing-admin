include SessionsHelper
class Doctor < ActiveRecord::Base
  belongs_to :province
  belongs_to :city
  belongs_to :hospital
  belongs_to :department
  def pinyin
    self.spell_code = PinYin.abbr(self.name)
  end

  def set_pk_code
    if self.id&&self.id!=0
      self.id = id
    else
      self.id = pk_id_rules
    end
  end

end
