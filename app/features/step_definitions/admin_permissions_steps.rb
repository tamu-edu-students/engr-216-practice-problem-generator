When('I navigate to the {string} page') do |page_name|
  path = case page_name
  when "Custom Template"
            custom_template_path
  when "Practice"
            generation_path
  when "Admin Roles"
            admin_roles_path
  else
            raise "Unknown page name: #{page_name}"
  end

  visit path
end

And('I select {string} as Question Type') do |type|
  select type, from: 'Select Question Type'
end

Then('I should see an error message {string}') do |error_message|
  expect(page).to have_content(error_message)
end
