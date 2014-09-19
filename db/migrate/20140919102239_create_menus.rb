class CreateMenus < ActiveRecord::Migration
  def change
    create_table :menus do |t|
      t.string :name
      t.integer :parent_id
      t.string :table_name
      t.string :Model_class

      t.timestamps
    end
  end
end
