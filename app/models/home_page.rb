class HomePage < ActiveRecord::Base
  belongs_to :hospital, :foreign_key => :hospital_id
  belongs_to :department, :foreign_key => :department_id
  belongs_to :home_menu,:foreign_key => :home_menu_id
  # before_save :set_default_value
  # def set_default_value
  #   @hospital = Hospital.where(:id => self.hospital_id)
  #   self.hospital_name = @hospital.first.name if !@hospital.first.nil?
  #   @department = Department.where(:id => self.department_id)
  # end
end
