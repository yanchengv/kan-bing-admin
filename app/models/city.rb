class City < ActiveRecord::Base
  belongs_to(:province, :class_name => "Province", :foreign_key => "province_id")
  has_many(:counties, :class_name => "County",:foreign_key => "city_id")
end
