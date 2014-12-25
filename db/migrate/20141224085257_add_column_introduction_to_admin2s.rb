class AddColumnIntroductionToAdmin2s < ActiveRecord::Migration
  def change
    add_column :admin2s, :introduction, :string
  end
end
