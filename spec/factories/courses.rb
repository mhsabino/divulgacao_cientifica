FactoryGirl.define do
  factory :course do
    sequence(:name) { |n| "Name_#{n}" }
    university

    trait :invalid do
      name nil
      university nil
    end

    factory :invalid_course, traits: [:invalid]
  end
end
