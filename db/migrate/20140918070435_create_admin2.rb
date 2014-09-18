class CreateAdmin2 < ActiveRecord::Migration
  def change
    create_table :admin2s do |t|
      # t.integer :id
      t.string :name,  null: false, default: ""
      t.string :email, null: false, default: ""
      t.string :photo
      t.string :password_digest, null: false, default: ""
      t.string :remember_token
      t.string :reset_password_token
      t.datetime :reset_password_sent_at
      t.datetime :remember_created_at
      t.integer :sign_in_count, default: 0, null: false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string :current_sign_in_ip
      t.string :last_sign_in_ip
      t.string :confirmation_token
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at
      t.string :unconfirmed_email
      t.integer :failed_attempts , default: 0, null: false
      t.string :unlock_token
      t.datetime :locked_at

      t.timestamps
    end
    add_index :admin2s, :name,                unique: true
    add_index :admin2s, :email,                unique: true
    add_index :admin2s, :reset_password_token, unique: true
    add_index :admin2s, :confirmation_token,   unique: true
    add_index :admin2s, :unlock_token,         unique: true
  end
end
