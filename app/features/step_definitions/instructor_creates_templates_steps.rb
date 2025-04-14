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
  fill_in "Question Template Text", with: "Calculate [v] using [x], [a], and [t]"
  fill_in "Equation", with: "x + a * t"
  fill_in "Variables", with: "x, a, t"
  fill_in "Variable Ranges", with: "1-2, 3-4, 5-6"
  fill_in "Variable Decimals", with: "0, 0, 0"
  fill_in "Answer", with: ""
  fill_in "Round Decimals", with: "2"
  fill_in "Explanation", with: "v = x + a*t"
  select "Motion", from: "Topic"
  select "Free Response", from: "Type"
end

When("I fill in an invalid equation") do
  fill_in "Question Template Text", with: "Broken formula"
  fill_in "Equation", with: "x + ("
  fill_in "Variables", with: "x"
  fill_in "Variable Ranges", with: "1-5"
  fill_in "Variable Decimals", with: "0"
  fill_in "Round Decimals", with: "2"
  select "Motion", from: "Topic"
  select "Free Response", from: "Type"
end

When("I fill in valid dataset data") do
  fill_in "Question Text", with: "Find the mean of dataset [ D ]"
  fill_in "Dataset Generator", with: "10-20, size=5"
  select "Mean", from: "Answer Type"
  fill_in "Explanation", with: "Mean is the average."
  select "Motion", from: "Topic"
  select "Free Response", from: "Select Type"
end

When("I fill in valid definition data") do
  fill_in "Definition", with: "The force that resists motion"
  fill_in "Answer", with: "Friction"
  fill_in "Explanation", with: "Friction is the resistance."
  select "Motion", from: "Topic"
  select "Free Response", from: "Type"
end

Then("a new question with kind {string} should exist") do |kind|
  expect(Question.where(question_kind: kind)).to exist
end

Then("I should be redirected to the instructor home page") do
  expect(page).to have_current_path(instructor_home_path)
end
