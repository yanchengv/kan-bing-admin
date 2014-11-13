class HomePage < ActiveRecord::Base
  belongs_to :hospital, :foreign_key => :hospital_id
  has_many :page_blocks, :foreign_key => :page_id
end
