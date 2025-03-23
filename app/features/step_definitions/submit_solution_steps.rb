And("I input the correct solution") do
  problem_text = find(:xpath, "//p[contains(text(), 'initial velocity')]").text

  u = problem_text.match(/initial velocity of (\d+(?:\.\d+)?)/)[1].to_f
  a = problem_text.match(/accelerates at a constant rate (\d+(?:\.\d+)?)/)[1].to_f
  t = problem_text.match(/for a time (\d+(?:\.\d+)?)/)[1].to_f

  final_velocity = u + a * t
  # Assuming the problem instructs to round to 2 decimals:
  final_velocity = final_velocity.round(2)
  fill_in "answer_input", with: final_velocity
end

And("I input an incorrect solution") do
  fill_in "answer_input", with: "999"
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
