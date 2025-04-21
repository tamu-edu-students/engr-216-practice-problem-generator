Given("the following topics exist:") do |table|
  table.hashes.each do |row|
    topic = Topic.find_or_initialize_by(topic_id: row["topic_id"])
    topic.topic_name = row["topic_name"]
    topic.save!
  end
end

Given("the following types exist:") do |table|
  table.hashes.each do |row|
    type = Type.find_or_initialize_by(type_id: row["type_id"])
    type.type_name = row["type_name"]
    type.save!
  end
end

When("I visit the equation template form") do
  visit custom_template_equation_path
end

When("I visit the dataset template form") do
  visit custom_template_dataset_path
end

When("I visit the definition template form") do
  visit custom_template_definition_path
end

When("I fill in valid equation data") do
  params = {
    question: {
      topic_id:          "1",
      type_id:           "1",
      template_text:     "Calculate [x]+[y]",
      equation:          "x+y",
      variables:         ["x", "y"],
      variable_ranges:   [
                          { "min" => "1", "max" => "5" },
                          { "min" => "1", "max" => "5" }
                        ],
      variable_decimals: ["0", "0"],
      round_decimals:    "0",
      explanation:       "Sum the values together"
    }
  }

  # Perform the POST as if the form had been submitted
  page.driver.submit :post,
                     custom_template_equation_path,
                     params
end

When("I fill in invalid equation data") do
  params = {
    question: {
      topic_id:          "1",
      type_id:           "1",
      template_text:     "Calculate [x]+[y]",
      equation:          "x+ (",
      variables:         ["x", "y"],
      variable_ranges:   [
                          { "min" => "1", "max" => "5" },
                          { "min" => "1", "max" => "5" }
                        ],
      variable_decimals: ["0", "0"],
      round_decimals:    "0",
      explanation:       "Sum the values together"
    }
  }

  # Perform the POST as if the form had been submitted
  page.driver.submit :post,
                     custom_template_equation_path,
                     params
end

When("I fill in valid dataset data") do
  params = {
    question: {
      topic_id:        "1",
      type_id:         "1",
      template_text:   "Given data [D], compute the mean",
      dataset_min:     "1",
      dataset_max:     "5",
      dataset_size:    "5",
      answer_strategy: "mean",
      explanation:     "Average value"
    }
  }

  # Perform the POST as if the form had been submitted
  page.driver.submit :post,
                     custom_template_dataset_path,
                     params
end

And("I fill in invalid dataset data") do
  params = {
    question: {
      topic_id:          "1",
      type_id:           "1",
      template_text:     "asfadsfs",              # missing text
      dataset_generator: "",              # missing generator
      answer_strategy:   "",              # missing strategy
      explanation:       ""
    }
  }
  page.driver.submit :post, custom_template_dataset_path, params
end

When("I fill in valid definition data") do
  params = {
    question: {
      topic_id:      "1",
      type_id:       "3",
      template_text: "Define inertia.",
      answer:        "Resistance to change in motion",
      explanation:   "Standard physics definition"
    }
  }

  page.driver.submit :post,
                     custom_template_definition_path,
                     params
end

When("I fill in invalid definition data") do
  params = {
    question: {
      topic_id:      "1",
      type_id:       "3",
      template_text: "asfsdfsd",
      answer:        "",
    }
  }
  page.driver.submit :post, custom_template_definition_path, params
end

Then("a new question with kind {string} should exist") do |kind|
  expect(Question.where(question_kind: kind)).to exist
end

Then("I should be redirected to the instructor home page") do
  expect(page).to have_current_path(instructor_home_path)
end

And("no question is created") do
  expect(Question.count).to eq(0)
end