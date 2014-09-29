class ConsultQuestion < ActiveRecord::Base
  has_many :consult_results, :foreign_key => :consult_id
  has_many :consult_accuses, :foreign_key => 'question_id'
  validates :consult_content, presence: true
end
