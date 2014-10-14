class Ecg < ActiveRecord::Base
  belongs_to :patient, :foreign_key => :patient_id
  attr_accessible  :id,:patient_id,:ecg_img ,:device_type ,:measure_time,:ahdId,:mdevice,:is_true,:int_ecg_img,:bit_ecg_img
end
