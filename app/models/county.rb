class County < ActiveRecord::Base
  belongs_to :province,  :foreign_key => "province_id"
  belongs_to :city, :foreign_key => "city_id"
end
