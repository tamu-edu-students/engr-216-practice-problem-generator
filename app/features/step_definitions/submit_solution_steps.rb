  And("I input the correct solution") do
    problem_text = find(:xpath, "//p[contains(text(), 'initial velocity')]").text

    # Extract the numbers from the problem statement using regex
    initial_velocity = problem_text.match(/initial velocity of (\d+)/)[1].to_i
    acceleration = problem_text.match(/accelerates at a constant rate (\d+)/)[1].to_i
    time = problem_text.match(/for a time (\d+)/)[1].to_i

    # Calculate the final velocity using the formula: v = u + at
    final_velocity = initial_velocity + (acceleration * time) * 1.0

    # Fill in the calculated answer in the input field
    fill_in "answer_input", with: final_velocity
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
