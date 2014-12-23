class HomeMenu < ActiveRecord::Base
  has_one :home_page, dependent: :destroy
end
