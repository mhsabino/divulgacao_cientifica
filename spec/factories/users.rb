FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "user_#{n}@email.com" }
    password 'letmein'
    role :admin

    trait :educator do
      role :educator
    end

    trait :student do
      role :educator
    end

    trait :secretary do
      role :secretary
    end

    trait :invalid do
      email nil
      password nil
      role nil
    end

    factory :educator_user, traits: [:educator]
    factory :student_user, traits: [:student]
    factory :secretary_user, traits: [:secretary]
    factory :invalid_user, traits: [:invalid]
  end
end
