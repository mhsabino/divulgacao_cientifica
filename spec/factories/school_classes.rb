FactoryGirl.define do
  factory :school_class do
    sequence(:name) { |n| "School_class_name_#{n}" }
    year DateTime.now.year
    period 1
    vacancies 30
    course

    trait :invalid do
      name nil
      year nil
      vacancies nil
      period nil
      course nil
    end

    factory :invalid_school_class, traits: [:invalid]
  end
end
