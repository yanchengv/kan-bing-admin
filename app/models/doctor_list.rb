class DoctorList < ActiveRecord::Base
  attr_accessible :consultation_id, :docmember_id,:id,:confirmed
  belongs_to :consultation
  belongs_to :docmember,class_name: "Doctor"
end
