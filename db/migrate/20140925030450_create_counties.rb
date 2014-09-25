class CreateCounties < ActiveRecord::Migration
  def change
    create_table :counties do |t|
      t.string :name
      t.integer :city_id
      t.integer :province_id

      t.timestamps
    end
  end
end
