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
    template_text: "Given the data: [D], determine the mean.",
    dataset_generator: "1-25, size=25",
    answer_strategy: "mean",
    question_kind: "dataset",
    answer: nil,
    correct_submissions: 0,
    total_submissions: 0,
    explanation: "Add up all the values in the dataset and divide by the number of values.",
    round_decimals: 2
  },
  {
    topic_id: topics[0].topic_id,
    type_id: types[1].type_id,
    template_text: "Given the data: [D], determine the median.",
    dataset_generator: "1-25, size=25",
    answer_strategy: "median",
    question_kind: "dataset",
    answer: nil,
    correct_submissions: 0,
    total_submissions: 0,
    explanation: "Sort the dataset and pick the middle value.",
    round_decimals: 0
  },
  {
    topic_id: topics[0].topic_id,
    type_id: types[1].type_id,
    template_text: "Given the data: [D], determine the mode.",
    dataset_generator: "1-25, size=25",
    answer_strategy: "mode",
    question_kind: "dataset",
    answer: nil,
    correct_submissions: 0,
    total_submissions: 0,
    explanation: "Identify the value that occurs most frequently in the dataset.",
    round_decimals: 0
  },
  {
    topic_id: topics[0].topic_id,
    type_id: types[1].type_id,
    template_text: "Given the data: [D], determine the range.",
    dataset_generator: "1-25, size=25",
    answer_strategy: "range",
    question_kind: "dataset",
    answer: nil,
    correct_submissions: 0,
    total_submissions: 0,
    explanation: "The range is the difference between the maximum and minimum values.",
    round_decimals: 0
  },
  {
    topic_id: topics[0].topic_id,
    type_id: types[1].type_id,
    template_text: "Given the data: [D], determine the standard deviation.",
    dataset_generator: "1-25, size=25",
    answer_strategy: "standard_deviation",
    question_kind: "dataset",
    answer: nil,
    correct_submissions: 0,
    total_submissions: 0,
    explanation: "Calculate the square root of the average of squared deviations from the mean.",
    round_decimals: 2
  },
  {
    topic_id: topics[0].topic_id,
    type_id: types[1].type_id,
    template_text: "Given the data: [D], determine the variance.",
    dataset_generator: "1-25, size=25",
    answer_strategy: "variance",
    question_kind: "dataset",
    answer: nil,
    correct_submissions: 0,
    total_submissions: 0,
    explanation: "The variance is the average of the squared differences from the mean.",
    round_decimals: 2
  },
  {
    topic_id: topics[1].topic_id,
    type_id: types[1].type_id,
    template_text: "The energy E of a particle is given by E = mgh, where m is the mass, g is the acceleration due to gravity, and h is the height. If m = [m] +/- [m_error] kg, g = [g] +/- [g_error] m/s², and h = [h] +/- [h_error] m, calculate the propagated error in joules for the energy. Assume that the errors are independent and random.",
    equation: "((g*h*m_error)**2 + (m*h*g_error)**2 + (m*g*h_error)**2)**(1/2.0)",
    variables: ["m_error", "m", "g_error", "g", "h_error", "h"],
    answer: nil,
    correct_submissions: 0,
    total_submissions: 0,
    explanation: "Use the error propagation formula for multiplication: ΔE = sqrt((g·h·Δm)² + (m·h·Δg)² + (m·g·Δh)²).",
    round_decimals: 2,
    variable_ranges: [[0.1, 10], [1, 100], [0.01, 1], [9.8, 10], [0.01, 1], [1, 100]],
    variable_decimals: [2, 2, 2, 2, 2, 2],
    question_kind: "equation"
  },
  {
    topic_id: topics[1].topic_id,
    type_id: types[1].type_id,
    template_text: "The temperature (T) of a substance isdetermined by the equation T=a*b, where a and b are measured parameters. If a = [a] +/- [a_error] and b = [b] +/- [b_error], calculate the propagated error in temperature. Assume that the errors are independent and random.",
    equation: "((b*a_error)**2 + (a*b_error)**2)**(1/2.0)",
    variables: ["a_error", "a", "b_error", "b"],
    answer: nil,
    correct_submissions: 0,
    total_submissions: 0, 
    explanation: "Use the error propagation formula for multiplication: ΔT = sqrt((b·Δa)² + (a·Δb)²).",
    round_decimals: 2,
    variable_ranges: [[0.1, 10], [1, 100], [0.01, 1], [1, 100]],
    variable_decimals: [2, 2, 2, 2],
    question_kind: "equation"
  },
  {
    topic_id: topics[2].topic_id,
    type_id: types[1].type_id,
    img: nil,
    template_text: "Use the forward difference approximation to estimate the first derivative of the following function: f(x) = [a]x^3 + [b]x^2 + [c]x + [d]. Evaluate the derivative at x = [x] using a step size of h = [h].",
    equation: '(a*(x+h)**3 + b*(x+h)**2 + c*(x+h) + d - (a*x**3 + b*x**2 + c*x + d)) / h',
    variables: ["a", "b", "c", "d", "x", "h"],
    answer: nil,
    correct_submissions: 0,
    total_submissions: 0,
    explanation: 'To solve this problem, use the forward difference approximation formula for the first derivative of a function. The formula is (f(x+h) - f(x)) / h.',
    round_decimals: 2,
    variable_ranges: [[1, 25], [1, 10], [1, 10], [1, 100], [1, 10], [0.01, 1]],
    variable_decimals: [2, 2, 2, 2, 2, 2],
    question_kind: "equation"
  },
  {
    topic_id: topics[2].topic_id,
    type_id: types[1].type_id,
    img: nil,
    template_text: "Use the backward difference approximation to estimate the first derivative of the following function: f(x) = [a]x^3 + [b]x^2 + [c]x + [d]. Evaluate the derivative at x = [x] using a step size of h = [h].",
    equation: '(a*x**3 + b*x**2 + c*x + d - (a*(x-h)**3 + b*(x-h)**2 + c*(x-h) + d)) / h',
    variables: ["a", "b", "c", "d", "x", "h"],
    answer: nil,
    correct_submissions: 0,
    total_submissions: 0,
    explanation: 'To solve this problem, use the backward difference approximation formula for the first derivative of a function. The formula is (f(x) - f(x-h)) / h.',
    round_decimals: 2,
    variable_ranges: [[1, 25], [1, 10], [1, 10], [1, 100], [1, 10], [0.01, 1]],
    variable_decimals: [2, 2, 2, 2, 2, 2],
    question_kind: "equation"
  },
  {
    topic_id: topics[2].topic_id,
    type_id: types[1].type_id,
    img: nil,
    template_text: "Use the centered difference approximation to estimate the first derivative of the following function: f(x) = [a]x^3 + [b]x^2 + [c]x + [d]. Evaluate the derivative at x = [x] using a step size of h = [h].",
    equation: '(a*(x+h)**3 + b*(x+h)**2 + c*(x+h) + d - (a*(x-h)**3 + b*(x-h)**2 + c*(x-h) + d)) / (2*h)',
    variables: ["a", "b", "c", "d", "x", "h"],
    answer: nil,
    correct_submissions: 0,
    total_submissions: 0,
    explanation: 'To solve this problem, use the centered difference approximation formula for the first derivative of a function. The formula is (f(x+h) - f(x-h)) / (2*h).',
    round_decimals: 2,
    variable_ranges: [[1, 25], [1, 10], [1, 10], [1, 100], [1, 10], [0.01, 1]],
    variable_decimals: [2, 2, 2, 2, 2, 2],
    question_kind: "equation"
  },
  {
    topic_id: topics[2].topic_id,
    type_id: types[1].type_id,
    img: nil,
    template_text: "Find the true derivative value of the following function: f(x) = [a]x^3 + [b]x^2 + [c]x + [d]. Evaluate the derivative at x = [x].",
    equation: '3*a*x**2 + 2*b*x + c',
    variables: ["a", "b", "c", "d", "x"],
    answer: nil,
    correct_submissions: 0,
    total_submissions: 0,
    explanation: 'To solve this problem, take the derivative of the function f(x) = ax^3 + bx^2 + cx + d. The derivative of this function is 3ax^2 + 2bx + c.',
    round_decimals: 2,
    variable_ranges: [[1, 25], [1, 10], [1, 10], [1, 100], [1, 10], [0.01, 1]],
    variable_decimals: [2, 2, 2, 2, 2, 2],
    question_kind: "equation"
  },
  {
    topic_id: topics[2].topic_id,
    type_id: types[1].type_id,
    img: nil,
    template_text: "A heat exchanger is used to cool a liquid flowing through a pipeline. The temperature of the liquid at one point in the pipeline is measured over time and recorded as the data given. Using the data, calculate the change in temperature with time at point 4 using a first order backward finite difference method. The data is given in the format Point x: (Time (s), Temperature (°C)). Data - Point 1: (10.0, [T1]); Point 2: (10.2, [T2]); Point 3: (10.4, [T3]); Point 4: (10.6, [T4]); Point 5: (10.8, [T5]).",
    equation: '(T4 - T3) / (10.6 - 10.4)',
    variables: ["T1", "T2", "T3", "T4", "T5"],
    answer: nil,
    correct_submissions: 0,
    total_submissions: 0,
    explanation: 'To solve this problem, use the backward finite difference method to estimate the change in temperature with time at point 4. The formula is (temperature_4 - temperature_3) / (time_4 - time_3).',
    round_decimals: 2,
    variable_ranges: [[80,85], [75,80], [70,75], [65,70], [60,65]],
    variable_decimals: [1, 1, 1, 1, 1],
    question_kind: "equation"
  },
  {
    topic_id: topics[3].topic_id,
    type_id: types[1].type_id,
    template_text: "Studies show the average production processing time required to repair an automatic loading machine in a complex food-packaging operation is [mean] minutes with a standard deviation of [std] minutes and follows a normal distribution. If the process is down for [x] minutes or longer, all equipment must be cleaned, with the loss of all product in process. Calculate the probability that the repair takes [x] minutes or longer. Construct a properly labeled distribution with x and z scales.",
    equation: "10.56",
    variables: ["mean", "std", "x"],
    answer: nil,
    correct_submissions: 0,
    total_submissions: 0,
    explanation: "First, compute the z-score: z = (x - mean) / std. Then use the your chart to find the corresponding CDF value.",
    round_decimals: 2,
    variable_ranges: [[120, 120], [4, 4], [125, 125]],
    variable_decimals: [0, 0, 0],
    question_kind: "equation"
  },
  {
    topic_id: topics[3].topic_id,
    type_id: types[1].type_id,
    template_text: "The life of a particular type of dry-cell battery is normally distributed with a mean of [mean] days and a standard deviation of [std] days. What fraction of these batteries would be expected to survive beyond [x] days?",
    equation: "6.68",
    variables: ["mean", "std", "x"],
    answer: nil,
    correct_submissions: 0,
    total_submissions: 0,
    explanation: "Calculate the z-score: z = (x - mean) / std. Then use the your chart to find the corresponding CDF value.",
    round_decimals: 2,
    variable_ranges: [[600,600], [60,60], [690,690]],
    variable_decimals: [0, 0, 0],
    question_kind: "equation"
  },
  {
    topic_id: topics[3].topic_id,
    type_id: types[1].type_id,
    template_text: "The life of a particular type of dry-cell battery is normally distributed with a mean of [mean] days and a standard deviation of [std] days. What fraction of these batteries would be expected to fail before [x] days?",
    equation: "22.66",
    variables: ["mean", "std", "x"],
    answer: nil,
    correct_submissions: 0,
    total_submissions: 0,
    explanation: "Calculate the z-score: z = (x - mean) / std. Then use the your chart to find the corresponding CDF value.",
    round_decimals: 2,
    variable_ranges: [[600,600], [60,60], [555,555]],
    variable_decimals: [0, 0, 0],
    question_kind: "equation"
  },
  {
    topic_id: topics[3].topic_id,
    type_id: types[1].type_id,
    template_text: "The heights of a population of adults are normally distributed with a mean of [mean] cm and a standard deviation of [std] cm. What is the probability (%) that a randomly selected adult is shorter than [x] cm? You should use the provided z-tables. Your answer should be a number between 0.0 and 100.0.",
    equation: "15.87",
    variables: ["mean", "std", "x"],
    answer: nil,
    correct_submissions: 0,
    total_submissions: 0,
    explanation: "Calculate the z-score: z = (x - mean) / std. Then use the your chart to find the corresponding CDF value.",
    round_decimals: 2,
    variable_ranges: [[160, 160], [5, 5], [155, 155]],
    variable_decimals: [0, 0, 0],
    question_kind: "equation"
  },
  {
    topic_id: topics[3].topic_id,
    type_id: types[1].type_id,
    template_text: "The monthly salaries of employees in a company are normally distributed with a mean of [mean] and a standard deviation of [std]. What is the probability (%) that a randomly selected employee earns more than [x] per month? You should use the provided z-tables. Your answer should be a number between 0.0 and 100.0.",
    equation: "15.87",
    variables: ["mean", "std", "x"],
    answer: nil,
    correct_submissions: 0,
    total_submissions: 0,
    explanation: "Calculate the z-score: z = (x - mean) / std. Then use the your chart to find the corresponding CDF value.",
    round_decimals: 2,
    variable_ranges: [[4000,4000], [500,500], [4500,4500]],
    variable_decimals: [0, 0, 0],
    question_kind: "equation"
  },
  {
    topic_id: topics[4].topic_id,
    type_id: types[1].type_id,
    template_text: "The life in hours of a 75-W light bulb is known to be approximately normally distributed, with a standard deviation of [sigma] hours. A random sample of [n] bulbs has a mean life of [mean] hours. Find the lower bound of a 95% confidence interval for the mean of all bulbs.",
    equation: "mean - 2.055*(sigma/(n**(1/2.0)))",
    variables: ["mean", "sigma", "n"],
    answer: nil,
    correct_submissions: 0,
    total_submissions: 0,
    explanation: "For a 95% confidence interval with a known standard deviation, use the formula: x̄ ± 1.96*(σ/√n). The lower bound is x̄ - 1.96*(σ/√n).",
    round_decimals: 2,
    variable_ranges: [[900,1500], [20,30], [15,25]],
    variable_decimals: [0, 0, 0],
    question_kind: "equation"
  },
  {
    topic_id: topics[4].topic_id,
    type_id: types[1].type_id,
    template_text: "The life in hours of a 75-W light bulb is known to be approximately normally distributed, with a standard deviation of [sigma] hours. A random sample of [n] bulbs has a mean life of [mean] hours. Find the upper bound of a 95% confidence interval for the mean of all bulbs.",
    equation: "mean + 1.96*(sigma/(n**(1/2.0)))",
    variables: ["mean", "sigma", "n"],
    answer: nil,
    correct_submissions: 0,
    total_submissions: 0,
    explanation: "For a 95% confidence interval with a known standard deviation, use the formula: x̄ ± 1.96*(σ/√n). The upper bound is x̄ + 1.96*(σ/√n).",
    round_decimals: 2,
    variable_ranges: [[900,1500], [20,30], [15,25]],
    variable_decimals: [0, 0, 0],
    question_kind: "equation"
  },
  {
    topic_id: topics[4].topic_id,
    type_id: types[1].type_id,
    template_text: "A manufacturer produces piston rings for an automobile engine. It is known that ring diameter is approximately normally distributed and has a standard deviation of [sigma] mm. A random sample of [n] rings has a mean diameter of [mean] mm. Construct a 99% confidence interval on the mean piston ring diameter. What is the range between boundaries?",
    equation: "2*2.575*sigma/(n**(1/2.0))",
    variables: ["mean", "sigma", "n"],
    answer: nil,
    correct_submissions: 0,
    total_submissions: 0,
    explanation: "For a 99% confidence interval, use z = 2.575. The margin of error is calculated as 2.575*(σ/√n). The range between boundaries is 2*margin of error.",
    round_decimals: 4,
    variable_ranges: [[50, 100], [0.001, 0.005], [15, 25]],
    variable_decimals: [3, 3, 0],
    question_kind: "equation"
  },
  {
    topic_id: topics[4].topic_id,
    type_id: types[1].type_id,
    template_text: "A cereal machine in the manufacturing plant is regulated such that it fills each box in a manner that approximates a normal distribution with a standard deviation of [sigma] oz. The guiding metric is a 96% confidence interval for the mean of all boxes. Today we pulled a random sample of [n] cereal boxes and measured an average content of [mean] oz. Find the lower boundary of the confidence interval.",
    equation: "mean - 2.055*(sigma/(n**(1/2.0)))",
    variables: ["mean", "sigma", "n"],
    answer: nil,
    correct_submissions: 0,
    total_submissions: 0,
    explanation: "For a 96% confidence interval, the z-value is approximately 2.055. The lower boundary is computed as mean - z*(sigma/√n).",
    round_decimals: 3,
    variable_ranges: [[20, 30], [0.5, 1.0], [40, 60]],
    variable_decimals: [1, 1, 0],
    question_kind: "equation"
  },
  {
    topic_id: topics[4].topic_id,
    type_id: types[1].type_id,
    template_text: "A cereal machine in the manufacturing plant is regulated such that it fills each box in a manner that approximates a normal distribution with a standard deviation of [sigma] oz. The guiding metric is a 96% confidence interval for the mean of all boxes. Today we pulled a random sample of [n] cereal boxes and measured an average content of [mean] oz. Find the upper boundary of the confidence interval.",
    equation: "mean + 2.055*(sigma/(n**(1/2.0)))",
    variables: ["mean", "sigma", "n"],
    answer: nil,
    correct_submissions: 0,
    total_submissions: 0,
    explanation: "For a 96% confidence interval, the z-value is approximately 2.055. The upper boundary is computed as mean + z*(sigma/√n).",
    round_decimals: 3,
    variable_ranges: [[20, 30], [0.5, 1.0], [40, 60]],
    variable_decimals: [1, 1, 0],
    question_kind: "equation"
  },
  {
    topic_id: topics[5].topic_id,
    type_id: types[1].type_id,
    template_text: "A roller coaster with mass [m] kg starts from rest at the top of a hill with a height of [h] meters and travels a total distance of [d] m to the bottom. If the air resistance (drag force) is [F] N, calculate the velocity (in m/s) of the roller coaster just before it reaches the bottom of the hill.",
    equation: "(2*((m*9.8*h) - (F*d))/m)**0.5",
    variables: ["m", "h", "d", "F"],
    answer: nil,
    correct_submissions: 0,
    total_submissions: 0,
    explanation: "Using energy conservation: the potential energy m*g*h is partially lost to work done against air resistance (F*d), leaving (1/2)*m*v^2 = m*g*h - F*d. Solving for v yields v = sqrt(2*(m*g*h - F*d)/m).",
    round_decimals: 2,
    variable_ranges: [[2000, 2400], [20, 40], [50, 70], [4750, 5250]],
    variable_decimals: [0, 0, 0, 0],
    question_kind: "equation"
  },
  {
    topic_id: topics[5].topic_id,
    type_id: types[1].type_id,
    template_text: "Blackberries and sugar are combined in a 60:40 mass ratio to make jam. Blackberries are 70% water and 30% solids, while sugar is 100% solids, and the mixture is heated to remove water until the final solids content is 75%. If blackberries cost $[b] per kg and sugar costs $[s]/kg, what is the cost of the blackberries in $ required to make 1 kg of jam?",
    equation: "75/(30+100*40/60.0)*b",
    variables: ["b", "s"],
    answer: nil,
    correct_submissions: 0,
    total_submissions: 0,
    explanation: "To find the cost of blackberries required to make 1kg of jam, use the equation cost = (75/(30+100*40/60))*b, where b is the cost of blackberries per kg.",
    round_decimals: 2,
    variable_ranges: [[1, 2], [0.10, 0.20]],
    variable_decimals: [2, 2],
    question_kind: "equation"
  },
  {
    topic_id: topics[5].topic_id,
    type_id: types[1].type_id,
    template_text: "Blackberries and sugar are combined in a 60:40 mass ratio to make jam. Blackberries are 70% water and 30% solids, while sugar is 100% solids, and the mixture is heated to remove water until the final solids content is 75%. If blackberries cost $[b] per kg and sugar costs $[s]/kg, what is the cost of the sugar in $ required to make 1 kg of jam?",
    equation: "75/(30+100*40/60.0)*4/60.0*s",
    variables: ["b", "s"],
    answer: nil,
    correct_submissions: 0,
    total_submissions: 0,
    explanation: "To find the cost of sugar required to make 1kg of jam, use the equation cost = (75/(30+100*40/60))*4/60*s, where s is the cost of sugar per kg.",
    round_decimals: 3,
    variable_ranges: [[1, 2], [0.10, 0.20]],
    variable_decimals: [2, 2],
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
    question_kind: "multiple_choice" # or "multiple_choice" if you distinguish
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
  #   topic_id: topics[3].topic_id,
  #   type_id: types[1].type_id,
  #   img: nil,
  #   template_text: 
  # }
