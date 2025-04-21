And("I select {string} from Select Type") do |string|
  select string, from: "Select Type"
end

And("I fill in valid multiple choice equation data") do
  params = {
    question: {
      topic_id: "1",
      type_id:  "2",
      template_text: "What is the value of e",
      answer_choices_attributes: {
        "0" => { "choice_text" => "2.71828",  "correct" => "true",  "_destroy" => "false" },
        "1" => { "choice_text" => "10", "correct" => "false", "_destroy" => "false" }
      },
      explanation: "e = 2.71828"
    }
  }

  page.driver.submit :post, custom_template_equation_path, params
end

And("I fill in valid multiple choice definition data") do
  params = {
    question: {
      topic_id: "1",
      type_id:  "2",
      template_text: "What is an object's resistance to motion called",
      answer_choices_attributes: {
        "0" => { "choice_text" => "Inertia",  "correct" => "true",  "_destroy" => "false" },
        "1" => { "choice_text" => "H", "correct" => "false", "_destroy" => "false" }
      },
      explanation: "Inertia is the correct answer"
    }
  }

  page.driver.submit :post, custom_template_definition_path, params
end

Then("a new question with kind {string} and type {string} should exist") do |kind, type_name|
  q = Question.order(created_at: :desc).find_by(question_kind: kind)
  expect(q).to be_present, "expected a Question with kind=#{kind.inspect} to exist"
  expect(q.type.type_name).to eq(type_name)
end
