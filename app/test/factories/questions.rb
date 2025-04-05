FactoryBot.define do
  factory :question do
    association :topic
    association :type

    img { nil }
    template_text { "What is velocity given position, acceleration, and time?" }
    equation { "x + a * t" }
    variables { ["x", "a", "t"] }
    answer { nil }
    correct_submissions { 0 }
    total_submissions { 0 }
    round_decimals { 2 }
    question_kind { "equation" }

    variable_ranges { [[1, 1], [2, 2], [3, 3]] }
    variable_decimals { [0, 0, 0] }

    # Optional traits for dataset and definition
    trait :definition do
      question_kind { "definition" }
      template_text { "The force that resists motion between two surfaces." }
      answer { "friction" }
      equation { nil }
      variables { [] }
    end

    trait :dataset do
      question_kind { "dataset" }
      template_text { "Find the mode of dataset: [ D ]" }
      dataset_generator { "10-20, size=5" }
      answer_strategy { "mode" }
      equation { nil }
      variables { [] }
    end
  end
end
