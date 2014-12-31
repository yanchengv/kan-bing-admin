class DoctorsSkill < ActiveRecord::Base
  belongs_to :doctor, foreign_key: :doctor_id
  belongs_to :skill, foreign_key: :skill_id
end
