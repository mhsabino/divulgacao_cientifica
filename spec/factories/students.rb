FactoryGirl.define do
  factory :student do
    sequence(:name) { |n| "student_name_#{n}" }
    sequence(:registration) { |n| "registration_#{n}@email.com" }
    sequence(:email) { |n| "student_email_#{n}@email.com" }
    university
    school_class

    trait :invalid do
      name nil
      registration nil
      email nil
      school_class nil
      university nil
    end

    factory :invalid_student, traits: [:invalid]
  end
end
