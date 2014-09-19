class CreateAdmin2Menus < ActiveRecord::Migration
  def change
    create_table :admin2_menus do |t|
      t.integer :admin2_id
      t.integer :menu_id

      t.timestamps
    end
  end
end
