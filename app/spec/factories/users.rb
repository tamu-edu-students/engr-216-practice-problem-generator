FactoryBot.define do
    factory :user do
      id { 999999999 }  
      first_name { "John" }
      last_name { "Doe" }
      email { "john.doe@tamu.edu" }
    end
  end
  