class CreateMenuPermissions < ActiveRecord::Migration
  def change
    create_table :menu_permissions do |t|
      t.integer :menu_id
      t.integer :admin2_id
      t.string  :hospital_id
      t.string :department_id
      t.boolean :is_show,:default => true
      t.boolean :is_edit,:default => false
      t.boolean :is_add,:default => false
      t.boolean :is_delete,:default => false
      t.boolean :is_manage,:default => false

      t.timestamps
    end
  end
end
