Given('the following multiple choice questions exist:') do |table|
  mc_type = Type.find_or_create_by!(type_name: "Multiple choice") do |type|
    type.type_id = 3
  end

  table.hashes.each do |row|
    topic = Topic.find_or_create_by!(topic_name: row["Topic"]) do |t|
      t.topic_id = Topic.maximum(:topic_id).to_i + 1
    end

    choices = row["Choices"].split(",").map(&:strip)
    correct = row["Correct Choice"].strip

    question = Question.create!(
      topic_id: topic.topic_id,
      type_id: mc_type.type_id,
      template_text: row["Question"],
      variables: [],
      equation: nil,
      answer: nil,
      correct_submissions: 0,
      total_submissions: 0,
      answer_choices_attributes: choices.map do |choice_text|
        {
          choice_text: choice_text,
          correct: (choice_text == correct)
      }
      end
    )
  end
end


Given('I have selected Multiple choice and Basic Arithmetic') do
  visit practice_form_path

  # Check the boxes for topic and type
  check 'Basic Arithmetic'
  check 'Multiple choice'

  click_button 'Submit'
end

Then('I should see four answer choices') do
  expect(page).to have_css('input[type=radio]', count: 4)
end

Then('I should be able to select one') do
  # Pick the first answer choice (simulate selection)
  find('input[type=radio]', match: :first).click
end

When('I select the correct answer choice') do
  # Find the radio with value "4" and select it (assuming radio value is the text of the answer)
  correct_choice = AnswerChoice.find_by(choice_text: "4", correct: true)
  choose("4")
end

When('I press submit') do
  click_button 'Submit'
end

Then('I should see feedback indicating the answer was correct') do
  expect(page).to have_content("✅ Correct")
end

Then('I should see the correct answer explanation') do
  expect(page).to have_content("Explanation")
end
