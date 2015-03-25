include SessionsHelper
class Organization < ActiveRecord::Base
  has_many :doctors
  has_many :patients
  before_create :set_pk_code

  def set_pk_code
    if self.id&&self.id!=0
      self.id = id
    else
      self.id = pk_id_rules
    end

  if self.hospital_id&&self.hospital_id!=0
    self.hospital_id = hospital_id
  else
    self.hospital_id = pk_id_rules
  end
  if self.department_id&&self.department_id!=0
    self.department_id = department_id
  else
    self.department_id = pk_id_rules
  end
end
end
