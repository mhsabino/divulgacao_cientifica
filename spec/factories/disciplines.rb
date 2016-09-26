FactoryGirl.define do
  factory :discipline do
    sequence(:name) { |n| "Name_#{n}" }
    description "Description"
    university
    course

    trait :invalid do
      name nil
      university nil
      course nil
    end

    factory :invalid_discipline, traits: [:invalid]
  end
end
