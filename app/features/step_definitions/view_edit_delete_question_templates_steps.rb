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

  
      # Create question
      question = Question.create!(
        topic_id: topic.topic_id,
        type_id: type.type_id,
        question_kind: row["Kind"] || row["question_kind"],
        template_text: row["Question"] || row["template_text"],
        variables: [],
        correct_submissions: 0,
        total_submissions: 0
      )
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
  
  Then("I should not see {string}") do |text|
    expect(page).not_to have_content(text)
  end
  