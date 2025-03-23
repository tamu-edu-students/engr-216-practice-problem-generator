Given("a predefined question exists with variables {string}, variable_ranges {string}, and variable_decimals {string}") do |vars, ranges, decimals|
    topic = Topic.find_or_create_by!(topic_name: "Velocity")
    type = Type.find_or_create_by!(type_name: "Free Response")
    @question = Question.create!(
      topic: topic,
      type: type,
      template_text: "Calculate final velocity with initial velocity \\(a\\) and acceleration time \\(b\\).",
      equation: nil,  # No equation needed; we're focusing on random value substitution
      variables: vars.split(",").map(&:strip),
      answer: nil,
      explanation: "Dummy explanation",
      round_decimals: 2,
      variable_ranges: ranges.split(",").map { |range_str| range_str.split("-").map { |v| v.strip.to_f } },
      variable_decimals: decimals.split(",").map { |d| d.strip.to_i }
    )
  end
  
  Then("the problem text should display values for {string} formatted with {int} and {int} decimal places respectively") do |var_list, dec_a, dec_b|
    # Fetch the problem text from the page
    problem_text = find("p", text: /Problem:/).text
    # Create a regex that expects the first value to have exactly dec_a decimal places 
    # and the second value to have exactly dec_b decimal places.
    regex = /(\d+\.\d{#{dec_a}}).*?(\d+\.\d{#{dec_b}})/
    matches = problem_text.match(regex)
    expect(matches).not_to be_nil
    @val_a = matches[1].to_f
    @val_b = matches[2].to_f
  end
  
  Then("the value for {string} should be between {float} and {float}") do |var, min, max|
    if var.strip.downcase == "a"
      expect(@val_a).to be >= min
      expect(@val_a).to be <= max
    elsif var.strip.downcase == "b"
      expect(@val_b).to be >= min
      expect(@val_b).to be <= max
    else
      raise "Unknown variable #{var}"
    end
  end