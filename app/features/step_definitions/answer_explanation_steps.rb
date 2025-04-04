When(/^I click "Try Another Problem" on the problem page$/) do
    within("form[action='#{try_another_problem_path}']") do
        click_button "Try Another Problem"
    end
end

Then(/^I should see the explanation for this answer$/) do
    expect(page).to have_content("Explanation:")
end
