When("I view the problem") do
  expect(page).to have_content("A car starts with an initial velocity of")
end

Then("the problem text should display values for {string} and {string} formatted with {int} and {int} decimal places respectively") do |var1, var2, dec1, dec2|
  problem_text = page.text

  # Create regex patterns for the expected decimal formats
  pattern1 = /\d+\.\d{#{dec1}}/
  pattern2 = /\d+\.\d{#{dec2}}/

  # Scan for all decimal numbers in the problem text
  decimals = problem_text.scan(/\d+\.\d+/)

  # Find first matching values with correct decimal places
  match1 = decimals.find { |num| num.match?(pattern1) }
  match2 = decimals.find { |num| num.match?(pattern2) && num != match1 }

  expect(match1).not_to be_nil, "Could not find a value with #{dec1} decimal places"
  expect(match2).not_to be_nil, "Could not find a value with #{dec2} decimal places"

  # Store values for later steps
  @var_values ||= {}
  @var_values[var1.strip.downcase] = match1.to_f
  @var_values[var2.strip.downcase] = match2.to_f
end
  
Then("the value for {string} should be between {float} and {float}") do |var, min, max|
  value = @var_values[var.strip.downcase]
  raise "No value stored for variable '#{var}'" unless value

  expect(value).to be >= min
  expect(value).to be <= max
end