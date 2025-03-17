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

When("I fill in {string} with {string}") do |field_label, value|
  fill_in field_label, with: value
end

When("I press on the button: {string}") do |button_text|
  click_button button_text
end

Then("I should see the string {string}") do |expected_text|
  expect(page).to have_content(expected_text)
end
