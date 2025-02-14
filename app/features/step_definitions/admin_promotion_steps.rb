Given('I am logged in as an administrator') do
    mock_valid_admin_google_account()
    visit '/auth/google_oauth2/callback'
end

Then('I should be on the accounts page') do
    expect(page).to have_current_path(admin_roles_path)
  end

Then('I should see a list of all accounts and their roles') do
    expect(page).to have_content("Role")
  end

  Given('I am on the view accounts page') do
    mock_valid_admin_google_account()
    visit '/auth/google_oauth2/callback'
    visit admin_roles_path
  end

  Given('there is an account with the student role') do
    @student = User.create!(
      first_name: 'John',
      last_name: 'Doe',
      email: 'john.doe@tamu.edu',
      role: 'student'
    )

    @student.save!
    visit admin_roles_path
  end

  When('I select instructor in the role dropdown') do
    within(:xpath, "//tr[td[contains(text(), 'john.doe@tamu.edu')]]") do
      select('Instructor', from: "role_select_#{User.find_by(email: 'john.doe@tamu.edu').id}")
    end
  end

  When('I click Update Role in that row') do
    within(:xpath, "//tr[td[contains(text(), 'john.doe@tamu.edu')]]") do
      click_button 'Update Role'
    end
  end

  Then('the selected account will have the instructor role') do
    expect(User.find_by(email: 'john.doe@tamu.edu').role).to eq('instructor')
  end
