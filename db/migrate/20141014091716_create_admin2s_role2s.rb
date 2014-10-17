class CreateAdmin2sRole2s < ActiveRecord::Migration
  def change
    create_table :admin2s_role2s do |t|
      t.integer :admin2_id
      t.integer :role2_id

      t.timestamps
    end
  end
end
