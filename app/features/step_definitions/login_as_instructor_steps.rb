Given('I have an instructor account') do
  mock_valid_instructor_google_account()
end

Then('I will be on the Instructor Homepage') do
    expect(page).to have_current_path(instructor_home_path)
end

When('I have an invalid instructor account') do
    mock_invalid_instructor_google_account()
end

And('I should see a message {string}') do |message|
    expect(page).to have_content(message)
end

Given("I have a valid student account") do
    mock_valid_google_account()
  end
  
  When("I visit the Instructor Homepage") do
    visit instructor_home_path
  end