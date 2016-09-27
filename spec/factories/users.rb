FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "user_#{n}@email.com" }
    password 'letmein'
  end
end
