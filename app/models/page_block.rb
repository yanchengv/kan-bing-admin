class PageBlock < ActiveRecord::Base
  belongs_to :home_page, :foreign_key => :page_id
  before_create :set_pk_code
  before_save :set_default_value
  def set_pk_code
    if self.id&&self.id!=0
      self.id = id
    else
      self.id = pk_id_rules
    end
  end

  def set_default_value
    @hospital = Hospital.where(:id => self.hospital_id)
    self.hospital_name = @hospital.first.name if !@hospital.first.nil?
    @department = Department.where(:id => self.department_id)
    self.department_name = @department.first.name if !@department.first.nil?
  end
end
