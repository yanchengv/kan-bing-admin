class Role2sMenuPermission < ActiveRecord::Base
  belongs_to :role2
  belongs_to :menu_permission
end