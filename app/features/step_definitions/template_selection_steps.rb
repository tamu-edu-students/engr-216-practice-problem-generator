When("I visit the template selector page") do
    visit create_custom_template_path
  end
  
  When("I select {string} from the question type dropdown") do |type|
    select type, from: "question_type"
  end
  
  Then("I should be on the equation template form") do
    expect(current_path).to eq(custom_template_equation_path)
  end
  
  Then("I should be on the dataset template form") do
    expect(current_path).to eq(custom_template_dataset_path)
  end
  
  Then("I should be on the definition template form") do
    expect(current_path).to eq(custom_template_definition_path)
  end
  
  Then("I should be on the template selector page") do
    expect(current_path).to eq(new_template_selector_path)
  end