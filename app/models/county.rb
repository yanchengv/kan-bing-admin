class County < ActiveRecord::Base
=begin
  belongs_to :@province, :foreign_key => :province_id
  belongs_to :@cities, :foreign_key => :city_id
  attr_accessor :name, :city_id, :province_ids
=end
end
