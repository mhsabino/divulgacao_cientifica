FactoryGirl.define do
  factory :university do
    sequence(:name) { |n| "University_#{n}" }

    trait :invalid do
      name nil
    end

    factory :invalid_university, traits: [:invalid]
  end
end
