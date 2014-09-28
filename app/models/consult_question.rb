class ConsultQuestion < ActiveRecord::Base
  has_many :consult_results, :foreign_key => :consult_id, :dependent => :destroy
  has_many :consult_accuses, :foreign_key => 'question_id', :dependent => :destroy
  validates :consult_content, presence: true
end
