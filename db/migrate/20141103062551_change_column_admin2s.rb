class ChangeColumnAdmin2s < ActiveRecord::Migration
  def change
    remove_column :admin2s, :email
    add_column :admin2s, :email, :string
  end
end
