# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

Question.destroy_all
Type.destroy_all
Topic.destroy_all

case ActiveRecord::Base.connection.adapter_name
when "PostgreSQL"
  ActiveRecord::Base.connection.execute("ALTER SEQUENCE topics_id_seq RESTART WITH 1;")
  ActiveRecord::Base.connection.execute("ALTER SEQUENCE types_id_seq RESTART WITH 1;")
  ActiveRecord::Base.connection.execute("ALTER SEQUENCE questions_id_seq RESTART WITH 1;")
when "SQLite"
  ActiveRecord::Base.connection.execute("DELETE FROM sqlite_sequence WHERE name='topics';")
  ActiveRecord::Base.connection.execute("DELETE FROM sqlite_sequence WHERE name='types';")
  ActiveRecord::Base.connection.execute("DELETE FROM sqlite_sequence WHERE name='questions';")
end

topics = Topic.create([
  { topic_id: 1, topic_name: "Basic Statistical Measurements" },
  { topic_id: 2, topic_name: "Propagation of Error" },
  { topic_id: 3, topic_name: "Finite Differences" },
  { topic_id: 4, topic_name: "Basic Experimental Statistics & Probabilities" },
  { topic_id: 5, topic_name: "Confidence Intervals" },
  { topic_id: 6, topic_name: "UAE (Universal Accounting Equation)" }
])

types = Type.create([
  { type_id: 1, type_name: "Definition" },
  { type_id: 2, type_name: "Free response" }
])

questions = Question.create([
  {
    topic_id: topics[0].topic_id,
    type_id: types[1].type_id,
    img: nil,
    template_text: "Given the data: [\\(a\\), \\(b\\), \\(c\\), \\(d\\), \\(e\\), \\(f\\), \\(g\\), \\(h\\), \\(i\\), \\(j\\), \\(k\\), \\(l\\), \\(m\\), \\(n\\), \\(o\\), \\(p\\), \\(q\\), \\(r\\), \\(s\\), \\(t\\), \\(u\\), \\(v\\), \\(w\\), \\(x\\), \\(y\\)] Determine the mean. Round your answer to two (2) decimal places. Example: 99.44 Do not include units. Do not use scientific notation",
    equation: '(a + b + c + d + e + f + g + h + i + j + k + l + m + n + o + p + q + r + s + t + u + v + w + x + y) / 25',
    variables: [ "a", "b", "c", "d", "e",
                 "f", "g", "h", "i", "j",
                 "k", "l", "m", "n", "o",
                 "p", "q", "r", "s", "t",
                 "u", "v", "w", "x", "y" ],
    answer: nil,
    correct_submissions: 0,
    total_submissions: 0,
    explanation: 'To solve this problem, take the sum of the values above and divide that sum by the number of values (25).'
  }
  # {
  #   topic_id: topics[2].topic_id,
  #   type_id: types[1].type_id,
  #   img: nil,
  #   template_text: "Use the forward difference approximation to estimate the first derivative of the following function: f(x) = \\(a\\)x^3 + \\(b\\)x^2 + \\(c\\)x + \\(d\\). Evaluate the derivative at x = \\(x\\) using a step size of \\(h\\). Round your answer to two (2) decimal places. Example: 99.44 Do not include units. Do not use scientific notation",
  #   equation: '(a*(x+h)^3 + b*(x+h)^2 + c*(x+h) + d - (a*x^3 + b*x^2 + c*x + d)) / h',
  #   variables: ["a", "b", "c", "d", "x", "h"],
  #   answer: nil,  # answer is computed via evaluate_equation in the controller
  #   correct_submissions: 0,
  #   total_submissions: 0,
  #   explanation: 'To solve this problem, use the forward difference approximation formula for the first derivative of a function. The formula is (f(x+h) - f(x)) / h.'
  # },
  # {
  #   topic_id: topics[2].topic_id,
  #   type_id: types[1].type_id,
  #   img: nil,
  #   template_text: "Use the backward difference approximation to estimate the first derivative of the following function: f(x) = \\(a\\)x^3 + \\(b\\)x^2 + \\(c\\)x + \\(d\\). Evaluate the derivative at x = \\(x\\) using a step size of \\(h\\). Round your answer to two (2) decimal places. Example: 99.44 Do not include units. Do not use scientific notation",
  #   equation: '(a*x^3 + b*x^2 + c*x + d - (a*(x-h)^3 + b*(x-h)^2 + c*(x-h) + d)) / h',
  #   variables: ["a", "b", "c", "d", "x", "h"],
  #   answer: nil,  # answer will be generated dynamically
  #   correct_submissions: 0,
  #   total_submissions: 0,
  #   explanation: 'To solve this problem, use the backward difference approximation formula for the first derivative of a function. The formula is (f(x) - f(x-h)) / h.'
  # },
  # {
  #   topic_id: topics[2].topic_id,
  #   type_id: types[1].type_id,
  #   img: nil,
  #   template_text: "Use the centered difference approximation to estimate the first derivative of the following function: f(x) = \\(a\\)x^3 + \\(b\\)x^2 + \\(c\\)x + \\(d\\). Evaluate the derivative at x = \\(x\\) using a step size of \\(h\\). Round your answer to two (2) decimal places. Example: 99.44 Do not include units. Do not use scientific notation",
  #   equation: '(a*(x+h)^3 + b*(x+h)^2 + c*(x+h) + d - (a*(x-h)^3 + b*(x-h)^2 + c*(x-h) + d)) / (2*h)',
  #   variables: ["a", "b", "c", "d", "x", "h"],
  #   answer: nil,  # computed via evaluate_equation in the controller
  #   correct_submissions: 0,
  #   total_submissions: 0,
  #   explanation: 'To solve this problem, use the centered difference approximation formula for the first derivative of a function. The formula is (f(x+h) - f(x-h)) / (2*h).'
  # },
  # {
  #   topic_id: topics[2].topic_id,
  #   type_id: types[1].type_id,
  #   img: nil,
  #   template_text: "Find the true derivative value of the following function: f(x) = \\(a\\)x^3 + \\(b\\)x^2 + \\(c\\)x + \\(d\\). Evaluate the derivative at x = \\(x\\). Round your answer to two (2) decimal places. Example: 99.44 Do not include units. Do not use scientific notation",
  #   equation: '3*a*x^2 + 2*b*x + c',
  #   variables: ["a", "b", "c", "d", "x"],
  #   answer: nil,
  #   correct_submissions: 0,
  #   total_submissions: 0,
  #   explanation: 'To solve this problem, take the derivative of the function f(x) = ax^3 + bx^2 + cx + d. The derivative of this function is 3ax^2 + 2bx + c.'
  # },
  # {
  #   topic_id: topics[2].topic_id,
  #   type_id: types[1].type_id,
  #   img: nil,
  #   template_text: "A heat exchanger is used to cool a liquid flowing through a pipeline. The temperature of the liquid at one point in the pipeline is measured over time and recorded as the data given. Using the data, calculate the change in temperature with time at point 4 using a first order backward finite difference method. The data is given in the format Point x: (Time (s), Temperature (°C)). Data - Point 1: (\\(t1\\), \\(T1\\)); Point 2: (\\(t2\\), \\(T2\\)); Point 3: (\\(t3\\), \\(T3\\)); Point 4: (\\(t4\\), \\(T4\\)); Point 5: (\\(t5\\), \\(T5\\)). Round your answer to two (2) decimal places. Example: 99.44 Do not include units. Do not use scientific notation",
  #   equation: '(T4 - T3) / (t4 - t3)',
  #   variables: ["t1", "T1", "t2", "T2", "t3", "T3", "t4", "T4", "t5", "T5"],
  #   answer: nil,
  #   correct_submissions: 0,
  #   total_submissions: 0,
  #   explanation: 'To solve this problem, use the backward finite difference method to estimate the change in temperature with time at point 4. The formula is (temperature_4 - temperature_3) / (time_4 - time_3).'
  # },
  # {
  #   topic_id: topics[3].topic_id,
  #   type_id: types[1].type_id,
  #   img: nil,
  #   template_text: 
  # }
])
