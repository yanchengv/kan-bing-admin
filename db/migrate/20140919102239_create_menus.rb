class CreateMenus < ActiveRecord::Migration
  def change
    create_table :menus do |t|
      t.string :name
      t.integer :parent_id
      t.string :uri
      t.string :table_name
      t.string :model_class

      t.timestamps
    end
  end
end
