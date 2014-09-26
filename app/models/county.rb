class County < ActiveRecord::Base
  belongs_to(:province, :class_name => "Province", :foreign_key => "province_id")
  belongs_to(:city,:class_name => "City",:foreign_key => "city_id")
end
