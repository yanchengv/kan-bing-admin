class CreateRole2Menus < ActiveRecord::Migration
  def change
    create_table :role2_menus do |t|
      t.integer :role2_id
      t.integer :menu_id

      t.timestamps
    end
  end
end
