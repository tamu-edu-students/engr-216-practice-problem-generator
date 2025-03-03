Given(/^"([^"]+)" has completed (\d+) problems with (\d+) correct answers$/) do |first_name, total, correct|
    @student = User.create!(
      first_name: first_name,
      last_name: 'last_name',
      email: first_name+'@tamu.edu',
      role: 'student',
      total_submissions: total.to_i,
      correct_submissions: correct.to_i
    )
end

When(/^I visit the leaderboard page$/) do
    visit leaderboard_path
  end

Then(/^the system displays "([^"]+)" then "([^"]+)" then "([^"]+)" on the leaderboard$/) do |first, second, third|
    body = page.body
    first_index  = body.index(first)
    second_index = body.index(second)
    third_index  = body.index(third)
    expect(first_index).to be < second_index
    expect(second_index).to be < third_index
end

Then(/^the system informs the student "([^"]+)"$/) do |inform_message|
    expect(page).to have_content(inform_message)
end

Then(/^the system does not have any message about rank or system$/) do
    expect(page).not_to have_content("Your current rank is")
    expect(page).not_to have_content("You are not currently on the leaderboard. Practice some problems to join the leaderboard.")
end
