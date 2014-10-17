class CreatePriorities < ActiveRecord::Migration
  def change
    create_table :priorities do |t|
      t.string :name
      t.string :code

      t.timestamps
    end
    add_column :menu_permissions,:priority_id,:integer
  end
end
