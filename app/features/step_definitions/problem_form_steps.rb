Given('I am logged in with a valid tamu email') do
    visit '/'
    mock_valid_google_account(email: 'user@tamu.edu', uid: '12345', name: 'TAMU User')
    click_on("Sign in with Google")
end

When('I visit the practice problems page') do
    visit practice_form_path
    expect(page).to have_content("Start Practice")
end

When /^I select the topics "(.*)" and "(.*)"$/ do |topic1, topic2|
    check("topic_ids_#{Topic.find_by(topic_name: topic1).topic_id}")
    check("topic_ids_#{Topic.find_by(topic_name: topic2).topic_id}")
end


When('I select the question types {string} and {string}') do |type1, type2|
    check("type_ids_#{Type.find_by(type_name: type1).type_id}")
    check("type_ids_#{Type.find_by(type_name: type2).type_id}")
end

And('I submit the form') do
    click_button 'Submit'
end

Then('I should be redirected to the problem generation page') do
    expect(current_path).to eq(generation_path)
end

Then('I should see {string} and {string}') do |item1, item2|
    expect(page).to have_content(item1)
    expect(page).to have_content(item2)
end
