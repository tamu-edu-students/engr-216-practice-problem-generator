Given('I navigate to the practice problems page') do
    visit problem_form_path
    expect(page).to have_content("Start a Practice Problem")
end

Given('I submit the topics selection') do
    click_button "Submit"
    expect(page).to have_current_path(problem_generation_path)
end

When('I generate a new problem') do
    visit problem_generation_path
end

Then('I should see the instruction {string}') do |round_info|
    expect(page).to have_content("#{round_info}")
end

Then('I should see the correct answer displayed in fixed decimal format') do
    answer_text = find('p', text: 'Correct Answer:').text
    expect(answer_text).to match(/\d+\.\d{2}/)
end
