class CreateBlockContents < ActiveRecord::Migration
  def change
    create_table :block_contents do |t|
      t.string :block_name
      t.string :title
      t.text :content
      t.string :url
      t.string :block_type
      t.date :create_date
      t.integer :block_id, :limit => 8

      t.timestamps
    end
  end
end
