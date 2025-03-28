Given("I am on the instructor home page") do
  mock_valid_instructor_google_account()
  visit instructor_home_path
end

When("I click on {string}") do |link_text|
  click_link link_text
end

When("I select {string} from {string}") do |option_text, dropdown_label|
  select option_text, from: dropdown_label
end

When("I fill in the new custom template form with:") do |table|
  # table is a Cucumber::MultilineArgument::DataTable
  data = table.rows_hash
  fill_in "Template Text", with: data["Template Text"]
  fill_in "Equation", with: data["Equation"]
  fill_in "Variables", with: data["Variables"]
  fill_in "Answer Format", with: data["Answer Format"]
  fill_in "Round Decimals", with: data["Round Decimals"]
  fill_in "Variable Ranges", with: data["Variable Ranges"]  # e.g., "2-3, 10-27"
  fill_in "Variable Decimals", with: data["Variable Decimals"]  # e.g., "2, 0"
  fill_in "Explanation", with: data["Explanation"]
end

When("I press on the button: {string}") do |button_text|
  click_button button_text
end

Then("I should see the string {string}") do |expected_text|
  expect(page).to have_content(expected_text)
end
