include SessionsHelper
class Department < ActiveRecord::Base
  belongs_to :province
  belongs_to :city
  belongs_to :hospital
  has_many :domains
  before_create :set_pk_code
  def set_pk_code
    if self.id&&self.id!=0
      self.id = id
    else
      self.id = pk_id_rules
    end
  end
end
