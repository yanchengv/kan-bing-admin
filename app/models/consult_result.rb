class ConsultResult < ActiveRecord::Base
  belongs_to :consult_question, :foreign_key => :consult_id, :dependent => :destroy
  has_many :consult_accuses, :foreign_key => 'result_id', :dependent => :destroy
end
