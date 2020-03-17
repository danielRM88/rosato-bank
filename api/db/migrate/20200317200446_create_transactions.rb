class CreateTransactions < ActiveRecord::Migration[5.2]
  def change
    create_table :transactions do |t|
      t.float :amount, required: true
      t.string :description, required: true
      t.references :account, foreign_key: true, required: true

      t.timestamps
    end
  end
end
