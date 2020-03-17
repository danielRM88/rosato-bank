class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :user_name,      limit: 50, required: false
      t.string :user_lastname,  limit: 50, required: false
      t.string :password_digest,           required: false
      t.string :email,                     required: false
      t.timestamps                         required: false
    end

    add_index :users, :email, unique: true
  end
end
