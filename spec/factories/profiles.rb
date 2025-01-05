FactoryBot.define do
  factory :profile do
    association :user
    image { Faker::Internet.url }
    is_active { Faker::Boolean.boolean }
  end
end
