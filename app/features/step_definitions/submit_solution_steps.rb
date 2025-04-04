And("I input the correct solution") do
  problem_text = page.text

  # Match numbers in the question's phrasing
  u_match = problem_text.match(/initial velocity of (\d+(?:\.\d+)?)/i)
  a_match = problem_text.match(/accelerates at a constant rate (\d+(?:\.\d+)?)/i)
  t_match = problem_text.match(/for a time (\d+(?:\.\d+)?)/i)

  unless u_match && a_match && t_match
    raise "Could not extract u, a, or t from problem text: #{problem_text}"
  end

  u = u_match[1].to_f
  a = a_match[1].to_f
  t = t_match[1].to_f

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
