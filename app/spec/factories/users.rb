FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    first_name { "John" }
    last_name { "Doe" }
    role { 0 } # Default to a regular user

    trait :instructor do
      role { 1 } # Instructor role
    end
  end
end
