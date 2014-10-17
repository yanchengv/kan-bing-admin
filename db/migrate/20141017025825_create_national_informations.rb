class CreateNationalInformations < ActiveRecord::Migration
  def change
    create_table :national_informations do |t|
      t.string :name
      t.integer :parent_id

      t.timestamps
    end
  end
end
