#author:wangfang
class Appointmentblacklist < ActiveRecord::Base
  # attr_accessible :unlock_time, :patient_id
  belongs_to :patient, :foreign_key => :patient_id
end
