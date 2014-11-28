class CreateBlockModels < ActiveRecord::Migration
  def change
    create_table :block_models do |t|
      t.string :title
      t.text :content
      t.string :desc
      t.text :example

      t.timestamps
    end
  end
end
