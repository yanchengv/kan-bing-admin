class MenuPermission < ActiveRecord::Base
  # belongs_to :admin2
  # belongs_to :menu
  belongs_to :hospital
  belongs_to :department
  belongs_to :menu
  belongs_to :priority
  has_many :role2s_menu_permissions, :dependent => :destroy
  has_many :role2s, :through => :role2s_menu_permissions, :source  => :role2
end
