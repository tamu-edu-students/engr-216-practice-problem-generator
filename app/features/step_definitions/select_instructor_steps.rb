Given("I am logged in as a student") do
  visit '/'
  mock_valid_google_account(email: 'user@tamu.edu', uid: '12345', name: 'TAMU User')
  click_on("Sign in with Google")

  @student_user = User.find_by(email: 'user@tamu.edu')
end

Given("an instructor user exists") do
  @instructor_user = User.create!(
    first_name: "Jane",
    last_name: "Instructor",
    email: "instructor@example.com",
    role: :instructor
  )
end

When("I visit my profile page") do
  visit user_path(@student_user.id)
end

Then("I should see b {string} in the page content") do |expected_text|
  expect(page).to have_content(expected_text)
end

Then("I should see b {string}") do |expected_text|
  expect(page).to have_content(expected_text)
end

When("I select that instructor from the dropdown") do
  select @instructor_user.full_name, from: 'instructor_id'
end

When("I do NOT select any instructor from the dropdown") do
  # idk do nothing?
  # just added this for syntax
end

When("I press star {string}") do |button_text|
  click_button button_text
end

Then("I should see the instructor's name in my profile") do
  expect(page).to have_content(@instructor_user.full_name)
end
