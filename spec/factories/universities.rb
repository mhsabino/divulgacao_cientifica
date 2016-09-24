FactoryGirl.define do
  factory :university do
    sequence(:name) { |n| "University_#{n}" }

    trait :invalid do
      name nil
    end
  end
end
