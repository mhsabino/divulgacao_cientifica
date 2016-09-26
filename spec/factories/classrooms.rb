FactoryGirl.define do
  factory :classroom do
    period :integral
    vacancies 30
    year { DateTime.now.year }
    discipline
    educator

    trait :invalid do
      period nil
      vacancies 0
      year ''
      discipline nil
    end

    factory :invalid_classroom, traits: [:invalid]
  end
end
