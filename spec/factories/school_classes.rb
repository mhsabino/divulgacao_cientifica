FactoryGirl.define do
  factory :school_class do
    sequence(:name) { |n| "School_class_name_#{n}" }
    year            { DateTime.now.year }
    period :integral
    vacancies 30
    course          { create(:course, university: university) }
    university

    trait :invalid do
      name nil
      year nil
      vacancies nil
      period nil
      course nil
      university nil
    end

    factory :invalid_school_class, traits: [:invalid]
  end
end
