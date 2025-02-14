Given('I am on the custom template page') do
  visit custom_template_path
end

When('I fill in {string} with {string}') do |field, value|
  fill_in field, with: value
end

When('I select {string} from {string}') do |value, field|
  select value, from: field
end

When('I click on {string}') do |link_or_button|
  puts "Looking for button or link: #{link_or_button}"
  click_link_or_button link_or_button
end

Then('I should be on the instructor home page') do
  expect(current_path).to eq(instructor_home_path)
end

Then('I should see the message {string}') do |text|
  expect(page).to have_content(text)
end