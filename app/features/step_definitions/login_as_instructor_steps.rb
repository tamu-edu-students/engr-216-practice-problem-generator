Given('I have an instructor account') do
  mock_valid_instructor_google_account()
end

Then('I will be on the Instructor Homepage') do
    expect(page).to have_current_path(instructor_home_path)
end

When('I have an invalid instructor account') do
    mock_invalid_instructor_google_account()
end
