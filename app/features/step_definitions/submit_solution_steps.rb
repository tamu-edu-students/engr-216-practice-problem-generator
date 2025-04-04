And("I input the correct solution") do
  problem_text = page.text

  # Extract all LaTeX-wrapped numbers like \( 3.2 \)
  matches = problem_text.scan(/\\\(\s*(\d+(?:\.\d+)?)\s*\\\)/)

  unless matches.size >= 3
    raise "Could not extract at least 3 values from problem text: #{problem_text}"
  end

  # Extract values in order: u, a, t
  u = matches[0][0].to_f
  a = matches[1][0].to_f
  t = matches[2][0].to_f

  # Compute equation: u + a * t
  final_velocity = (u + a * t).round(2)

  fill_in "answer_input", with: final_velocity
end

And("I input an incorrect solution") do
  fill_in "answer_input", with: "999"
end

And("I input the correct definition") do
  fill_in "answer_input", with: "The rate of change of position with respect to time."
end

And("I input an incorrect definition") do
  fill_in "answer_input", with: "The rate of change of position."
end

When("I click button {string}") do |button_text|
  click_button(button_text)
end

Then("I should see {string}") do |text|
  expect(page).to have_content(text)
end

Then("the user's counters should show a correct submission") do
  user = User.find_by(email: 'user@tamu.edu')
  expect(user.total_submissions).to eq(1)
  expect(user.correct_submissions).to eq(1)
end

Then("the user's counters should show an incorrect submission") do
  user = User.find_by(email: 'user@tamu.edu')
  expect(user.total_submissions).to eq(1)
  expect(user.correct_submissions).to eq(0)
end

Then("I print the user counters") do
  user = User.find_by(email: 'student@tamu.edu')
  puts "Debug => total: #{user.total_submissions}, correct: #{user.correct_submissions}"
end
