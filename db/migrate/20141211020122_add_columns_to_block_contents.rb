class AddColumnsToBlockContents < ActiveRecord::Migration
  def change
    add_column :block_contents, :content_url, :string
  end
end
