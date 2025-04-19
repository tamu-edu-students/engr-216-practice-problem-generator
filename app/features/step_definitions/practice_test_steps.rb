Given("another predefined question exists") do
    topic = Topic.find_or_create_by!(topic_name: "Accuracy and precision of measurements, error propagation")
    type = Type.find_or_create_by!(type_name: "Definition")

    @question = Question.create!(
        topic_id: topic.id,
        type_id: type.id,
        template_text: 'Define the term "accuracy" in the context of measurements.',
        equation: nil,
        variables: [],
        answer: 'Accuracy refers to how close a measured value is to the true value of the quantity being measured.',
        correct_submissions: 0,
        total_submissions: 0
    )
end

Given('I visit the practice page') do
    visit practice_form_path
    expect(page).to have_content("Start Practice")
end

Then('I should be redirected to the practice test generation page') do
    expect(page).to have_current_path(generation_path)
end

And("I should see multiple randomly selected problems") do
    problems = all(".question-block")
    expect(problems.count).to be > 1
end

And("I should see multiple input fields to submit my answers") do
    input_fields = all("input[type='text'][id='answer_input']")
    expect(input_fields.count).to be > 1
end

When("I answer all the questions") do
    all("input[type='text'][id='answer_input']").each_with_index do |input, index|
      input.fill_in with: "Test Answer #{index + 1}"
    end
end

And("I submit my practice exam") do
    click_button "Submit Test"
end

Then("I should see my score") do
    expect(page).to have_content("Your Score:")
end

Then("I should receive feedback on my test answers") do
    expect(page).to have_content(/Correct|Incorrect/)
end

Given("I don't select any topics") do
    # Ensure the topics dropdown or checkboxes exist but are not selected
    expect(page).to have_selector("#topics-dropdown, input[name='topic_ids[]']", visible: true)

    # Ensure no topic options are selected
    all("input[name='topic_ids[]']").each do |checkbox|
      expect(checkbox).not_to be_checked
    end
end

And("I don't select any question types") do
    expect(page).to have_selector("#types-dropdown, input[name='type_ids[]']", visible: true)

    all("input[name='type_ids[]']").each do |checkbox|
      expect(checkbox).not_to be_checked
    end
end

And('I should be redirected to the practice test form page') do
    expect(page).to have_current_path(practice_form_path)
end

Given("I enable Practice Test Mode") do
    check("practice_test_mode", allow_label_click: true)
end

Then("I should see {string} in the problem list") do |expected_text|
    expect(page).to have_content(expected_text)
end

Given('a predefined multiple choice question exists') do
    topic = Topic.find_or_create_by!(topic_name: "General Knowledge") do |t|
        t.topic_id = 5
    end

    mc_type = Type.find_or_create_by!(type_name: "Multiple choice") do |t|
        # Assign a type_id if needed. Adjust as appropriate.
        t.type_id = 3
      end

    @mc_question = Question.create!(
        topic_id: topic.topic_id,
        type_id: mc_type.type_id,
        template_text: "What is the capital of France?",
    )

    @mc_choices = [
        AnswerChoice.create!(question: @mc_question, choice_text: "Paris", correct: true),
        AnswerChoice.create!(question: @mc_question, choice_text: "London", correct: false),
        AnswerChoice.create!(question: @mc_question, choice_text: "Berlin", correct: false)
    ]
end

Given('I have selected Multiple choice and General Knowledge') do
    visit practice_test_form_path
    # Check the boxes for topic and type
    check 'General Knowledge'
    check 'Multiple choice'
end

Then('I should see three answer choices') do
    expect(page).to have_content('Paris')
    expect(page).to have_content('London')
    expect(page).to have_content('Berlin')
    expect(page).to have_css('.form-check', count: 3)
end

Given("a predefined range question exists") do
    topic = Topic.find_or_create_by!(topic_id: 4, topic_name: "Statistics")
    type = Type.find_or_create_by!(type_name: "Free Response")
    @question = Question.create!(
        topic_id: topic.id,
        type_id: type.id,
        question_kind: "dataset",
        template_text: 'Given the dataset [D], calculate the range of the values.',
        equation: nil,
        variables: [],
        answer: nil,
        correct_submissions: 0,
        total_submissions: 0,
        explanation: 'The range is the difference between the maximum and minimum values.',
        round_decimals: 2,
        dataset_generator: '1-100,size=8',
        answer_strategy: 'range'
    )
end

Given("a predefined standard deviation question exists") do
    topic = Topic.find_or_create_by!(topic_id: 4, topic_name: "Statistics")
    type = Type.find_or_create_by!(type_name: "Free Response")
    @question = Question.create!(
        topic_id: topic.id,
        type_id: type.id,
        question_kind: "dataset",
        template_text: 'Given the dataset [D], calculate the standard deviation of the values.',
        equation: nil,
        variables: [],
        answer: nil,
        correct_submissions: 0,
        total_submissions: 0,
        explanation: 'Calculate the square root of the average of squared deviations from the mean.',
        round_decimals: 2,
        dataset_generator: '1-100,size=8',
        answer_strategy: 'standard_deviation'
    )
end

Given("a predefined variance question exists") do
    topic = Topic.find_or_create_by!(topic_id: 4, topic_name: "Statistics")
    type = Type.find_or_create_by!(type_name: "Free Response")
    @question = Question.create!(
        topic_id: topic.id,
        type_id: type.id,
        question_kind: "dataset",
        template_text: 'Given the dataset [D], calculate the range of the values.',
        equation: nil,
        variables: [],
        answer: nil,
        correct_submissions: 0,
        total_submissions: 0,
        explanation: 'The variance is the average of the squared differences from the mean.',
        round_decimals: 2,
        dataset_generator: '1-100,size=8',
        answer_strategy: 'variance'
    )
end
