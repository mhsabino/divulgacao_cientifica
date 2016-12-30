FactoryGirl.define do
  factory :student do
    sequence(:name)         { |n| "student_name_#{n}" }
    sequence(:registration) { |n| "registration_#{n}" }
    university
    school_class            { create(:school_class, university: university) }
    user

    trait :invalid do
      name nil
      registration nil
      school_class nil
      university nil
      user nil
    end

    factory :invalid_student, traits: [:invalid]
  end
end
