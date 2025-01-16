FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    cpf { Faker::CPF.pretty }
    birthdate { Faker::Date.birthday(min_age: 18, max_age: 65) }
    role { "regular_user" }

    trait :with_profile do
      after(:create) do |user|
        create(:profile, user: user, is_active: true)
      end
    end
  end
end
