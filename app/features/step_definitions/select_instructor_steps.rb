Given('I am logged in as a student') do  
    @instructor = FactoryBot.create(:user, :instructor, first_name: "Test", last_name: "Professor", email: "instructorTEST@tamu.edu")
    
    visit '/'
    mock_valid_google_account(email: 'student@tamu.edu', uid: '67890', name: "Test Student")
    click_on("Login with Google")
  end
  
  Given('I am on the profile view') do
    visit user_path(User.last.id) # Ensure correct user profile is visited
    expect(page).to have_content("Howdy #{User.last.first_name}!")
  end
  
  When('I click the dropdown menu of CSCE 216 instructors') do
    find('select#instructor_id').click
  end
  
  When('I select my instructor') do
    expect(page).to have_select("instructor_id", with_options: [@instructor.full_name])
    select @instructor.full_name, from: 'instructor_id'
  end
  
  When("I click the 'Save Instructor' button") do
    click_button 'Save Instructor'
  end
  
  Then('the selected instructor will be opted in to view my practice problem results') do
    student = User.last
    instructor = User.find_by(role: 1)
  
    expect(student.reload.instructor_id).to eq(instructor.id)
    expect(page).to have_content("Instructor saved successfully!")
    expect(page).to have_content("Instructor: #{instructor.full_name}")
  end
  
  When('I do not select an instructor from the dropdown menu of CSCE 216 instructors') do
    # No action, user skips selection
  end
  
  When("I do not click 'Submit'") do
    # No action, user does not submit form
  end
  
  Then('my instructor will not be opted in to view my practice problem results') do
    student = User.last
    expect(student.reload.instructor_id).to be_nil
  end
  