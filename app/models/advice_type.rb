class AdviceType < ActiveRecord::Base
  has_many :medical_advices, :dependent => :destroy
end
