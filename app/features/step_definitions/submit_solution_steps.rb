And("I input the correct solution") do
    fill_in "answer_input", with: question.answer
  end
  
  And("I input an incorrect solution") do
    fill_in "answer_input", with: "999"
  end
  
  Then("I should be redirected to a results page") do
    expect(current_path).to eq(problem_result_path)
  end
  
  Then("I should see {string}") do |text|
    expect(page).to have_content(text)
  end