class ChangeAdmin2sPhoto < ActiveRecord::Migration
  def change
    rename_column :admin2s, :photo, :mobile_phone
    add_column :admin2s, :photo, :string
  end
end
