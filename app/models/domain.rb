class Domain < ActiveRecord::Base
  belongs_to :department
  belongs_to :hospital
end
