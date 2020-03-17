FactoryBot.define do
  factory :user do
    user_name Faker::Name.first_name
    user_lastname Faker::Name.unique.last_name
    email Faker::Internet.unique.safe_email
    password '123'
  end
end
