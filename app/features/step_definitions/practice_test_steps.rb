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

Given('I visit the practice tests page') do
    visit practice_test_form_path
    expect(page).to have_content("Start a Practice Test")
end

Then('I should be redirected to the practice test page') do
    expect(page).to have_current_path(practice_test_generation_path)
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
