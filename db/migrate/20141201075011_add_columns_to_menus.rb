class AddColumnsToMenus < ActiveRecord::Migration
  def change
    add_column :menus, :dep_admin_show, :boolean
    add_column :menus, :hos_admin_show, :boolean
  end
end
