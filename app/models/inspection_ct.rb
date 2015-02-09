include SessionsHelper
include HealthRecordsHelper
class InspectionCt < ActiveRecord::Base
  before_create :set_pk_code
  after_create :create_inspection_report
  after_destroy :delete_inspection_report
  belongs_to :patient, :foreign_key => :patient_id
  def set_pk_code
    self.id = pk_id_rules
  end
end
