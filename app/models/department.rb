class Department < ActiveRecord::Base
  belongs_to :province
  belongs_to :city
  belongs_to :hospital
end
