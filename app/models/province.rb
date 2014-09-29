class Province < ActiveRecord::Base
  has_many(:cities, :class_name => "City", :foreign_key => "province_id", :dependent => :destroy)
  has_many(:counties, :class_name => "County", :foreign_key => "province_id")
end
