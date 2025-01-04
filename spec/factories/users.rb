FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    cpf { Faker::CPF.pretty }
    birthdate { Faker::Date.birthday(min_age: 18, max_age: 65) }

    association :profile
  end
end
