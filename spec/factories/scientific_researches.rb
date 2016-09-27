FactoryGirl.define do
  factory :scientific_research do
    sequence(:name) { |n| "name_#{n}" }
    description "Description"
    educator
    university

    trait :invalid do
      name nil
      educator nil
      university nil
    end

    factory :invalid_scientific_research, traits: [:invalid]
  end
end
