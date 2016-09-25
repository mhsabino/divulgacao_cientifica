FactoryGirl.define do
  factory :educator do
    sequence(:name) { |n| "Name_#{n}" }
    sequence(:registration) { |n| "registration_#{n}" }
    university
    course

    trait :invalid do
      name nil
      registration_ nil
      university nil
    end

    factory :invalid_educator, traits: [:invalid]
  end
end
