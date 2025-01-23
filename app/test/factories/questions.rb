FactoryBot.define do
  factory :question do
    question_id { 1 }
    topic_id { nil }
    type_id { nil }
    img { "MyString" }
    template_text { "MyText" }
    equation { "MyText" }
    variables { "MyString" }
    answer { "MyText" }
    correct_submissions { 1 }
    total_submissions { 1 }
  end
end
