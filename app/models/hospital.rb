class Hospital < ActiveRecord::Base
  belongs_to :province
  belongs_to :city
end
