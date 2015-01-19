class MedicalDiagnose < ActiveRecord::Base
  belongs_to :diagnose_type, :foreign_key => :diagnose_type_id, :dependent => :destroy
end
