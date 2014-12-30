class AddContentSummaryToBlockContent < ActiveRecord::Migration
  def change
    add_column :block_contents, :content_summary, :text
  end
end
