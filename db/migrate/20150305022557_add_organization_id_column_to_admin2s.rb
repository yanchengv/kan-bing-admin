class AddOrganizationIdColumnToAdmin2s < ActiveRecord::Migration
  def change
    add_column :admin2s, :organization_id, :integer, :limit => 8
  end
end
