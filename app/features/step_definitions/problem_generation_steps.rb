Given("a predefined question exists") do
  topic = Topic.find_or_create_by!(topic_name: "Velocity")
  type = Type.find_or_create_by!(type_name: "Free Response")

  @question = Question.create!(
    topic_id: topic.id,
    type_id: type.id,
    img: nil,
    question_kind: "equation",
    template_text: 'A car starts with an initial velocity of [ u ] and accelerates at a constant rate [ a ] for a time [ t ]. Calculate the final velocity, v, of the car.',
    equation: 'u + a * t',
    variables: [ "u", "a", "t" ],
    answer: nil,
    correct_submissions: 0,
    total_submissions: 0,
    explanation: 'The final velocity of the car is the initial velocity plus the product of the acceleration and time.',
    round_decimals: 2,
    variable_ranges: [ [ 1, 10 ], [ 10, 20 ], [ 20, 30 ] ],
    variable_decimals: [ 1, 2, 3 ],
    dataset_generator: nil,
    answer_strategy: nil
  )
end

Given("a predefined dataset question exists") do
  topic = Topic.find_or_create_by!(topic_id: 4, topic_name: "Statistics")
  type = Type.find_or_create_by!(type_name: "Free Response")

  @question = Question.create!(
    topic_id: topic.id,
    type_id: type.id,
    question_kind: "dataset",
    template_text: 'Given the dataset [D], calculate the mean of the values.',
    equation: nil,
    variables: [],
    answer: nil,
    correct_submissions: 0,
    total_submissions: 0,
    explanation: 'The mean is calculated by summing all numbers in the dataset and dividing by the number of values.',
    round_decimals: 2,
    dataset_generator: '1-100, size=8',
    answer_strategy: 'mean'
  )
end

Given("a predefined median question exists") do
  topic = Topic.find_or_create_by!(topic_id: 4, topic_name: "Statistics")
  type = Type.find_or_create_by!(type_name: "Free Response")
  @question = Question.create!(
    topic_id: topic.id,
    type_id: type.id,
    question_kind: "dataset",
    template_text: 'Given the dataset [D], calculate the median of the values.',
    equation: nil,
    variables: [],
    answer: nil,
    correct_submissions: 0,
    total_submissions: 0,
    explanation: 'The median is the middle value in a sorted dataset. If the dataset has an even number of values, the median is the average of the two middle values.',
    round_decimals: 2,
    dataset_generator: '1-100,size=8',
    answer_strategy: 'median'
  )
end

Given("a predefined mode question exists") do
  topic = Topic.find_or_create_by!(topic_id: 4, topic_name: "Statistics")
  type = Type.find_or_create_by!(type_name: "Free Response")
  @question = Question.create!(
    topic_id: topic.id,
    type_id: type.id,
    question_kind: "dataset",
    template_text: 'Given the dataset [D], calculate the mode of the values.',
    equation: nil,
    variables: [],
    answer: nil,
    correct_submissions: 0,
    total_submissions: 0,
    explanation: 'The mode is the value that appears most frequently in the dataset. If no number repeats, there is no mode.',
    round_decimals: 2,
    dataset_generator: '1-100,size=8',
    answer_strategy: 'mode'
  )
end

Given("a predefined definition question exists") do
  Question.destroy_all
  topic = Topic.find_or_create_by!(topic_name: "Velocity")
  type = Type.find_or_create_by!(type_name: "Free Response")

  @question = Question.create!(
    topic_id: topic.id,
    type_id: type.id,
    question_kind: "definition",
    template_text: 'What is the definition of velocity?',
    equation: nil,
    variables: [],
    answer: "The rate of change of position with respect to time.",
    correct_submissions: 0,
    total_submissions: 0,
    explanation: 'Velocity is defined as the rate of change of position with respect to time.',
  )
end

And("I select topic {string}") do |topic|
  check("topic_ids_#{Topic.find_by(topic_name: topic).topic_id}")
end

And("I select question type {string}") do |type|
  check("type_ids_#{Type.find_by(type_name: type).type_id}")
end

And("I press {string}") do |button|
  click_button button
end

Then("I should be on the problem generation page") do
  expect(current_path).to eq(generation_path)
end

And("I should see a randomly selected problem") do
  expect(page).to have_content("Problem:")
  expect(page).to have_content("Enter your answer:")
end

And("I should see an input field to submit my answer") do
  expect(page).to have_field("answer_input")
end

Given("a problem with variables {string}, {string}, and {string}") do |var1, var2, var3|
  expect(@question.variables).to match_array([ var1, var2, var3 ])
end

When("the problem is displayed") do
  visit generation_path
end

Then("the values for {string}, {string}, and {string} should be randomly generated") do |var1, var2, var3|
  rendered_text = page.text

  expect(rendered_text).to match(/\d+/)  # Ensure numbers are in the text
  expect(rendered_text).not_to include("[ #{var1} ]")
  expect(rendered_text).not_to include("[ #{var2} ]")
  expect(rendered_text).not_to include("[ #{var3} ]")
end

And("the question text should include these values") do
  formatted_text = page.text

  @question.variables.each do |var|
    expect(formatted_text).not_to include("[ #{var} ")  # Make sure variables were replaced with numbers
  end
end

Then("I should see a list of numbers representing the dataset") do
  expect(page.text).to match(/\d+(,\s*\d+)+/)
end

And("the question text should include the dataset values") do
  dataset_text = @question.dataset_generator ? ProblemUtil.generate_dataset(@question.dataset_generator).join(", ") : ""
  expect(page).to have_content(dataset_text)
end

Then("I should see the definition question") do
  expect(page).to have_content(@question.template_text)
end
