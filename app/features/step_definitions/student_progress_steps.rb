Given('I am logged in') do
  visit '/'
  mock_valid_google_account(email: 'user@tamu.edu', uid: '12345', name: 'TAMU User')
  click_on("Login with Google")

  @user = User.find_by(email: 'user@tamu.edu')
end

Given('the following submissions exist:') do |table|
  table.hashes.each do |row|
    topic = Topic.find_or_create_by!(topic_name: row["Topic"])

    type = Type.find_or_create_by!(type_name: "Free Response")

    question = Question.find_or_create_by!(topic: topic, type: type, template_text: row["Question"])

    Submission.create!(user: @user, question: question, correct: row["Correct?"].downcase == "true")
  end
end

When('I navigate to the progress page') do
  visit user_progress_path(User.find_by(email: 'user@tamu.edu'))
end

Then('I should see my overall performance') do
  expect(page).to have_content("Total Submissions: #{@user.total_submissions}")
  expect(page).to have_content("Correct Submissions: #{@user.correct_submissions}")
  expect(page).to have_content("Accuracy: #{@user.total_accuracy}%")
end

And("I should see my performance by topic") do
  topics = @user.submissions_by_topic

  topics.each do |topic, stats|
    expect(page).to have_content(topic)
    within("table#progress_table") do
      expect(page).to have_content(stats[:total_submissions].to_s)
      expect(page).to have_content(stats[:correct_submissions].to_s)
      expect(page).to have_content("#{stats[:accuracy]}%")
    end
  end
end
