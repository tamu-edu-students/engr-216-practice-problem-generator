Given("a predefined question exists") do
  topic = Topic.find_or_create_by!(topic_name: "Velocity")
  type = Type.find_or_create_by!(type_name: "Free Response")

  @question = Question.create!(
    topic_id: topic.id,
    type_id: type.id,
    template_text: 'A car starts with an initial velocity of \( u \) and accelerates at a constant rate \( a \) for a time \( t \). Calculate the final velocity, v, of the car.',
    equation: 'u + a * t',
    variables: [ "u", "a", "t" ],
    answer: nil,
    correct_submissions: 0,
    total_submissions: 0,
    explanation: 'The final velocity of the car is the initial velocity plus the product of the acceleration and time.'
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
  expect(current_path).to eq(problem_generation_path)
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
  visit problem_generation_path
end

Then("the values for {string}, {string}, and {string} should be randomly generated") do |var1, var2, var3|
  # Extract the rendered text and check for random values
  rendered_text = page.text

  expect(rendered_text).to match(/\d+/)  # Ensure numbers are in the text
  expect(rendered_text).not_to include("\\( #{var1} \\)")
  expect(rendered_text).not_to include("\\( #{var2} \\)")
  expect(rendered_text).not_to include("\\( #{var3} \\)")
end

And("the question text should include these values") do
  formatted_text = page.text

  @question.variables.each do |var|
    expect(formatted_text).not_to include("\\( #{var} \\)")  # Make sure variables were replaced with numbers
  end
end
