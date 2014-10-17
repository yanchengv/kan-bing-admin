class CreateRole2s < ActiveRecord::Migration
  def change
    create_table :role2s do |t|
      t.string :name
      t.string :code
      t.text :instruction

      t.timestamps
    end
    create_table :role2s_menu_permissions do |t|
      t.integer :role2_id
      t.integer :menu_permission_id
    end
  end
end
