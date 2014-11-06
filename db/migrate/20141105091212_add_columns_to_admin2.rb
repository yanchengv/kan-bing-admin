class AddColumnsToAdmin2 < ActiveRecord::Migration
  def change
    add_column :admin2s, :hospital_id, :integer, :limit => 8
    add_column :admin2s, :department_id, :integer, :limit => 8
    add_column :admin2s, :admin_type, :string
  end
end
