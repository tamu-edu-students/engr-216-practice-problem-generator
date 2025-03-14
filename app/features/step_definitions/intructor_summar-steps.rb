Given("I am logged in as a person instructor") do
  mock_valid_instructor_google_account(
    email: 'instructor@tamu.edu',
    uid: '99999',
    name: 'TAMU Instructor'
  )
  
  # Visit the route that initiates (or finalizes) your app's OmniAuth flow
  # EXAMPLE: If your config/routes.rb has something like:
  #   get '/auth/google_oauth2/callback', to: 'sessions#create'
  visit "/auth/google_oauth2/callback"
end

When("I navigate to the instructor summary report page") do
  visit instructor_home_summary_path
end

Then("I should see star {string}") do |text|
  expect(page).to have_content(text)
end