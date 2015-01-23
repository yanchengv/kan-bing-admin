class DiagnoseType < ActiveRecord::Base
  has_many :medical_diagnoses#, :dependent => :destroy
end
