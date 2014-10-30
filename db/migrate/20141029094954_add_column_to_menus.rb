class AddColumnToMenus < ActiveRecord::Migration
  def change
    add_column :menus, :is_show, :boolean
  end
end
