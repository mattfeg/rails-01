FactoryBot.define do
  factory :profile do
    association :user
    image { 'https://akamai.sscdn.co/uploadfile/letras/fotos/9/5/0/9/950983aea9b60fd6c9f130a9c22bece0.jpg' }
    is_active { true }
  end
end
