# db/seeds.rb

# Clear existing records
AnswerChoice.destroy_all
Question.destroy_all
Type.destroy_all
Topic.destroy_all

# Reset primary key sequences
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

# Topics
topics = Topic.create!([
  { topic_id: 1, topic_name: "Basic Statistical Measurements" },
  { topic_id: 2, topic_name: "Propagation of Error" },
  { topic_id: 3, topic_name: "Finite Differences" },
  { topic_id: 4, topic_name: "Basic Experimental Statistics & Probabilities" },
  { topic_id: 5, topic_name: "Confidence Intervals" },
  { topic_id: 6, topic_name: "UAE (Universal Accounting Equation)" }
])

# Types
types = Type.create!([
  { type_id: 1, type_name: "Definition" },
  { type_id: 2, type_name: "Free response" },
  { type_id: 3, type_name: "Multiple choice" }
])

# Questions
questions = Question.create!([
  {
    topic_id: topics[0].topic_id,
    type_id: types[1].type_id,
    template_text: "Given the data: [\\(a\\), \\(b\\), \\(c\\), \\(d\\), \\(e\\), \\(f\\), \\(g\\), \\(h\\), \\(i\\), \\(j\\), \\(k\\), \\(l\\), \\(m\\), \\(n\\), \\(o\\), \\(p\\), \\(q\\), \\(r\\), \\(s\\), \\(t\\), \\(u\\), \\(v\\), \\(w\\), \\(x\\), \\(y\\)] Determine the mean.",
    equation: '(a + b + c + d + e + f + g + h + i + j + k + l + m + n + o + p + q + r + s + t + u + v + w + x + y) / 25',
    variables: %w[a b c d e f g h i j k l m n o p q r s t u v w x y],
    answer: nil,
    correct_submissions: 0,
    total_submissions: 0,
    explanation: 'To solve this problem, take the sum of the values above and divide that sum by the number of values (25).',
    round_decimals: 3,
    variable_ranges: Array.new(25) { [1, 25] },
    variable_decimals: Array.new(25, 1),
    question_kind: "equation"
  },
  {
    topic_id: topics[1].topic_id,
    type_id: types[1].type_id,
    template_text: "Divide \\(a\\) by \\(b\\).",
    equation: 'a / b',
    variables: ["a", "b"],
    answer: nil,
    correct_submissions: 0,
    total_submissions: 0,
    explanation: 'To solve this problem, divide the value of a by the value of b.',
    round_decimals: 3,
    variable_ranges: [[10, 100], [2, 10]],
    variable_decimals: [0, 2],
    question_kind: "equation"
  },
  {
    topic_id: topics[0].topic_id,
    type_id: types[2].type_id,
    template_text: "Which of the following units measures force?",
    equation: nil,
    variables: [],
    answer: "Newtons",
    correct_submissions: 0,
    total_submissions: 0,
    explanation: "Force is measured in Newtons.",
    round_decimals: nil,
    variable_ranges: [],
    variable_decimals: [],
    question_kind: "definition" # or "multiple_choice" if you distinguish
  }
])

# Optional: AnswerChoices for the multiple choice question
force_question = questions.last

AnswerChoice.create!([
  { question_id: force_question.id, choice_text: "Joule", correct: false },
  { question_id: force_question.id, choice_text: "Watt", correct: false },
  { question_id: force_question.id, choice_text: "Newton", correct: true },
  { question_id: force_question.id, choice_text: "Pascal", correct: false }
])
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

AnswerChoice.create!([
  { question: questions[2], choice_text: "Joule", correct: false },
  { question: questions[2], choice_text: "Watt", correct: false },
  { question: questions[2], choice_text: "Newton", correct: true },
  { question: questions[2], choice_text: "Pascal", correct: false }
])
