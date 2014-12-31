class DoctorsGroup < ActiveRecord::Base
  belongs_to :doctor, foreign_key: :doctor_id
  belongs_to :group, foreign_key: :group_id
end
