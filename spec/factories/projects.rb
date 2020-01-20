FactoryBot.define do
  
  factory :project do
    title { Faker::Movies::StarWars.character }
    description { Faker::Movies::StarWars.quote }
    due_date { Faker::Date.between(from: 1.day.from_now, to: 60.days.from_now) }
    
    association(:user, factory: :user)
  end
end
