FactoryBot.define do
    factory :submission do
      association :user
      association :question
      correct { false }
    end
  end
