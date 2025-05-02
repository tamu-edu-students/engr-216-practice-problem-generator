  Given('the following questions exist:') do |table|
    instructor = FactoryBot.create(:user, :instructor)

    table.hashes.each do |row|
      # Create/find type and topic
      type = Type.find_or_create_by!(type_name: row["Type"] || "Generic") do |t|
        t.type_id ||= Type.maximum(:type_id).to_i + 1
      end

      topic = Topic.find_or_create_by!(topic_name: row["Topic"] || "General") do |t|
        t.topic_id ||= Topic.maximum(:topic_id).to_i + 1
      end

      question_kind = row["Kind"] || row["question_kind"]
      template_text = row["template_text"]


      attrs = {
        topic_id: topic.topic_id,
        type_id: type.type_id,
        question_kind: question_kind,
        template_text: template_text,
        variables: [],
        correct_submissions: 0,
        total_submissions: 0
      }

      if question_kind == "equation"
        attrs[:equation] = row["Equation"] || "x * 2"
      end

      Question.create!(attrs)
    end
  end


  Given("there are no questions") do
    Question.delete_all
  end

  When("I visit the instructor questions page") do
    visit instructor_questions_path
  end

  When("I click {string} for {string}") do |action, text|
    within(:xpath, "//tr[td[contains(.,'#{text}')]]") do
      click_on action
    end
  end

  When("I select {string} from the {string} filter") do |option, filter|
    select option, from: filter
  end

  When("I fill in {string} with {string}") do |field, value|
    fill_in field, with: value
  end

  When("I edit in valid equation data") do
    fill_in "question[variables][]", with: "x"
    fill_in "question[variable_ranges][][min]", with: "1"
    fill_in "question[variable_ranges][][max]", with: "300"
    fill_in "question[variable_decimals][]", with: "0"


    fill_in "Round Decimals", with: "2"
    fill_in "Explanation", with: "This is a test explanation."
  end

  Then("I should not see {string}") do |text|
    expect(page).not_to have_content(text)
  end
