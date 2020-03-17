class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :user_name,      limit: 50, null: false
      t.string :user_lastname,  limit: 50, null: false
      t.string :password_digest,           null: false
      t.string :email,                     null: false
      t.timestamps                         null: false
    end

    add_index :users, :email, unique: true
  end
end
