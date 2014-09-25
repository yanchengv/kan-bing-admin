class CreateProvinces < ActiveRecord::Migration
  def change
    create_table :provinces do |t|
      t.string :name
      t.string :short_name
      t.string :spell_name
      t.string :en_abbreviation

      t.timestamps
    end
  end
end
