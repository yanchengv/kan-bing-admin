class CreateMenuUris < ActiveRecord::Migration
  def change
    create_table :menu_uris do |t|
      t.string :menu_name
      t.string :menu_uri
      t.text :instruction

      t.timestamps
    end
  end
end
