class CreateAccounts < ActiveRecord::Migration[5.2]
  def change
    create_table :accounts do |t|
      t.float :balance, required: true, default: 0.0
      t.references :user, foreign_key: true, required: true
      t.string :number, required: true

      t.timestamps
    end
  end
end
