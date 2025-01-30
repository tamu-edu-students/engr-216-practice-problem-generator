Given('I am on the student homepage') do
    mock_valid_google_account()
    visit student_home_path
end

Given('I am logged in as an instructor') do
    mock_valid_instructor_google_account()
    visit '/auth/google_oauth2/callback'
end

Given('I am on the instructor homepage') do
    visit instructor_home_path
end

Then('I will be on the welcome page') do
    expect(page).to have_current_path(welcome_path)
end
