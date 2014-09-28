class ConsultAccuse < ActiveRecord::Base
  belongs_to :consult_question, :foreign_key => :question_id
  belongs_to :consult_result, :foreign_key => :result_id

end
