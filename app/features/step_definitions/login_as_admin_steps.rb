Given('I have an admin account') do
    mock_valid_admin_google_account()
  end
  
  Then('I will be on the Admin Homepage') do
    expect(page).to have_current_path(admin_path)
  end
  
  When('I have an invalid admin account') do
    mock_invalid_admin_google_account()
  end

  Given('I do not have an admin account') do
    mock_valid_google_account()
  end
  
  When('I try to access the admin page') do
    visit admin_path
  end