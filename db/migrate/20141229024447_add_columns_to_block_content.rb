class AddColumnsToBlockContent < ActiveRecord::Migration
  def change
    add_column :block_contents, :subtitle, :string
  end
end
