class ConsultResult < ActiveRecord::Base
  belongs_to :consult_question, :foreign_key => :consult_id
  has_many :consult_accuses, :foreign_key => 'result_id'
end
