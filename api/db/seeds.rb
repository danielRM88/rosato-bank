# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
user = User.create!(user_name: 'Daniel', user_lastname: 'Rosato', email: 'test@test.com', password: '123')
user2 = User.create!(user_name: 'John', user_lastname: 'Doe', email: 'test2@test.com', password: '123')
account = Account.create!(balance: 100.0, user: user, number: '123456789')
account2 = Account.create!(balance: 500.0, user: user2, number: '987654321')

account.transactions.create!(amount: 10, description: "Income")
account.transactions.create!(amount: -4.75, description: "Groceries")
TransferService.transfer(account, account2, 25.4)
account.transactions.create!(amount: -15, description: "Rent")
account.transactions.create!(amount: -5, description: "Electricity")
account.transactions.create!(amount: 25.3, description: "Income")
TransferService.transfer(account, account2, 5)
TransferService.transfer(account2, account, 15)
account.transactions.create!(amount: -3, description: "Groceries")
account.transactions.create!(amount: -1.45, description: "Groceries")
account.transactions.create!(amount: -4.32, description: "Groceries")
account.transactions.create!(amount: -5.1, description: "Groceries")
account.transactions.create!(amount: -1.25, description: "Groceries")
