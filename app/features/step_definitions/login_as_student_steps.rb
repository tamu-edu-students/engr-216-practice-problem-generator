# Navigate to the welcome page
Given('I am on the welcome page') do
  visit '/' # Replace with the actual path for the welcome page
end

# Simulate clicking "Sign in with Google"
When('I click {string}') do |button_text|
    click_on(button_text)
end

# Mock a valid TAMU Google account and simulate login
When('I have a valid @tamu Google account') do
  mock_valid_google_account(email: 'user@tamu.edu', uid: '12345', name: 'TAMU User')
end

# Mock a non-TAMU Google account and simulate login
When('I have a non-tamu Google account') do
  mock_invalid_google_account(email: 'user@gmail.com', uid: '54321', name: 'Gmail User')
end

# Verify the user is on the Student homepage
Then('I will be on the Student homepage') do
  expect(page).to have_current_path(student_home_path) # Replace with the actual path
end

# Verify the user remains on the welcome page
Then('I should be on the welcome page') do
  expect(page).to have_current_path(welcome_path) # Replace with the actual path for the welcome page
end

Given('I am not logged in') do
    current_user = nil
end

When('I try to go to the student homepage') do
    visit student_home_path
end

Then('I should see the message {string}') do |message|
    expect(page).to have_content(message)
end
