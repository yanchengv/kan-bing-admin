class MedicalAdvice < ActiveRecord::Base
  belongs_to :advice_type, :foreign_key => :advice_type_id, :dependent => :destroy
end
