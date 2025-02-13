Given('I visit the practice tests page') do
    visit practice_test_form_path
    expect(page).to have_content("Start a Practice Test")
end
  
Then('I should be redirected to the practice test page') do
    expect(page).to have_current_path(practice_test_generation_path)
end

When('I answer all the questions') do
    pending # Write code here that turns the phrase above into concrete actions
end

Then('I should get a message saying {string}') do |string|
    pending # Write code here that turns the phrase above into concrete actions
end

When('I submit my practice exam') do
    pending # Write code here that turns the phrase above into concrete actions
end
  
Then('I should see my score') do
    pending # Write code here that turns the phrase above into concrete actions
end

Then('I should receive feedback on my test answers') do
    pending # Write code here that turns the phrase above into concrete actions
end