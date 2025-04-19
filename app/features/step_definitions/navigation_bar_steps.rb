  When('I am on any page of the application') do
    visit root_path
  end

  Then('I should see a navigation bar at the top of the screen') do
    expect(page).to have_css('nav.navbar', visible: true)
  end

  Then('the student navigation bar should have links to {string}, {string}, {string}, {string}, {string}, and {string}') do |home, profile, logout, practice, leaderboard, progress|
    expect(page).to have_link(home, href: student_home_path)
    expect(page).to have_link(profile, href: user_path(User.last.id))
    expect(page).to have_link(logout, href: logout_path)
    expect(page).to have_link(practice, href: practice_form_path)
    expect(page).to have_link(leaderboard, href: leaderboard_path)
    expect(page).to have_link(progress, href: user_progress_path(User.last.id))
  end

  Then('the instructor navigation bar should have links to {string}, {string}, {string}, {string}, and {string}') do |home, profile, logout, custom_template, student_progress_summary|
    expect(page).to have_link(home, href: instructor_home_path)
    expect(page).to have_link(profile, href: user_path(User.last.id))
    expect(page).to have_link(logout, href: logout_path)
    expect(page).to have_link(custom_template, href: custom_template_path)
    expect(page).to have_link(student_progress_summary, href: instructor_home_summary_path)
  end

  Given('I am logged in as an admin') do
    visit '/'
    mock_valid_admin_google_account()
    click_on("Login with Google")
  end

  Then('the admin navigation bar should have links to {string}, {string}, {string}, {string}, {string}, {string}, {string}, {string}, and {string}') do |home, profile, logout, view_accounts, practice, leaderboard, progress, custom_template, student_summary|
    expect(page).to have_link(home, href: admin_path)
    expect(page).to have_link(profile, href: user_path(User.last.id))
    expect(page).to have_link(logout, href: logout_path)
    expect(page).to have_link(view_accounts, href: admin_roles_path)
    expect(page).to have_link(practice, href: practice_form_path)
    expect(page).to have_link(leaderboard, href: leaderboard_path)
    expect(page).to have_link(progress, href: user_progress_path(User.last.id))
    expect(page).to have_link(custom_template, href: custom_template_path)
    expect(page).to have_link(student_summary, href: instructor_home_summary_path)
    expect(page).to have_link('Home', href: student_home_path)
    expect(page).to have_link('Home', href: instructor_home_path)
  end

  When('I click on the {string} link in the navigation bar') do |link|
    click_link link
  end

  Then('I should be redirected to the {string} page') do |page_name|
    expected_path = case page_name
    when 'Home'
                      case User.last.role
                      when 'student' then student_home_path
                      when 'instructor' then instructor_home_path
                      when 'admin' then admin_path
                      else root_path
                      end
    when 'Profile' then user_path(User.last.id)
    when 'Logout' then logout_path
    when 'Problems' then problem_form_path
    when 'Practice' then practice_form_path
    when 'Leaderboard' then leaderboard_path
    when 'Progress' then user_progress_path(User.last.id)
    when 'View Accounts' then admin_roles_path
    when 'Custom Template' then custom_template_path
    when 'Student Progress Summary' then instructor_home_summary_path
    else raise "Path for #{page_name} is not defined"
    end
    expect(page).to have_current_path(expected_path)
  end

  When('I am on the {string} page') do |page_name|
    step "I click on the '#{page_name}' link in the navigation bar"
  end

  Then('the {string} link on the navigation bar should be bold and underlined') do |link_text|
    expect(page).to have_css(".nav-links .nav-link.active-link", text: link_text)
  end
