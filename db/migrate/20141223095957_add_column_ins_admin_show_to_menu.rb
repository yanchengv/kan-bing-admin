class AddColumnInsAdminShowToMenu < ActiveRecord::Migration
  def change
    add_column :menus, :ins_admin_show, :boolean
  end
end
