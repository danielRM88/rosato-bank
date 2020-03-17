# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
user = User.create!(user_name: 'Daniel', user_lastname: 'Rosato', email: 'test@test.com', password: '123')
user2 = User.create!(user_name: 'John', user_lastname: 'Doe', email: 'test2@test.com', password: '123')
Account.create!(balance: 100.0, user: user, number: '123456789')
Account.create!(balance: 500.0, user: user2, number: '987654321')