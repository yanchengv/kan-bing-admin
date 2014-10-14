class TreatmentRelationship < ActiveRecord::Base
  attr_accessible :doctor_id, :patient_id
  belongs_to :doctor  ,foreign_key: :doctor_id
  belongs_to :patient ,foreign_key: :patient_id
  def self.is_friends(doctor_id,patient_id)
    flag = false
    if Patient.exists?(patient_id)
      @patient = Patient.find(patient_id)
      if @patient.doctor_id == doctor_id.to_i
        flag = true
      end
      if flag == false
        @trs = TreatmentRelationship.where(:doctor_id => doctor_id,:patient_id => patient_id)
        if @trs.count > 0
          flag = true
        end
      end
    end

    return flag
  end

end
