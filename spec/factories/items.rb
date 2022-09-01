FactoryBot.define do
  factory :item do
    name { Faker::Coffee.blend_name }
    description { Faker::TvShows::Simpsons.quote }
    unit_price { Faker::Number.within(range: 0.0..1.0) }
  end
end
