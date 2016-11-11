FactoryGirl.define do
  factory :educator do
    sequence(:name) { |n| "Name_#{n}" }
    sequence(:registration) { |n| "registration_#{n}" }
    university
    course
    user

    trait :invalid do
      name nil
      registration nil
      university nil
      user nil
      course nil
    end

    factory :invalid_educator, traits: [:invalid]
  end
end
