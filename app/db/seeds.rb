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
  { topic_id: 6, topic_name: "UAE (Universal Accounting Equation)" },
  { topic_id: 7, topic_name: "Rotational Motion" },
  { topic_id: 8, topic_name: "Harmonic Motion" },
  { topic_id: 9, topic_name: "Rigid Body Statics" },
  { topic_id: 10, topic_name: "Professional Ethics" }
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
    variables: [ "m_error", "m", "g_error", "g", "h_error", "h" ],
    answer: nil,
    correct_submissions: 0,
    total_submissions: 0,
    explanation: "Use the error propagation formula for multiplication: ΔE = sqrt((g·h·Δm)² + (m·h·Δg)² + (m·g·Δh)²).",
    round_decimals: 2,
    variable_ranges: [ [ 0.1, 10 ], [ 1, 100 ], [ 0.01, 1 ], [ 9.8, 10 ], [ 0.01, 1 ], [ 1, 100 ] ],
    variable_decimals: [ 2, 2, 2, 2, 2, 2 ],
    question_kind: "equation"
  },
  {
    topic_id: topics[1].topic_id,
    type_id: types[1].type_id,
    template_text: "The temperature (T) of a substance isdetermined by the equation T=a*b, where a and b are measured parameters. If a = [a] +/- [a_error] and b = [b] +/- [b_error], calculate the propagated error in temperature. Assume that the errors are independent and random.",
    equation: "((b*a_error)**2 + (a*b_error)**2)**(1/2.0)",
    variables: [ "a_error", "a", "b_error", "b" ],
    answer: nil,
    correct_submissions: 0,
    total_submissions: 0,
    explanation: "Use the error propagation formula for multiplication: ΔT = sqrt((b·Δa)² + (a·Δb)²).",
    round_decimals: 2,
    variable_ranges: [ [ 0.1, 10 ], [ 1, 100 ], [ 0.01, 1 ], [ 1, 100 ] ],
    variable_decimals: [ 2, 2, 2, 2 ],
    question_kind: "equation"
  },
  {
    topic_id: topics[2].topic_id,
    type_id: types[1].type_id,
    img: nil,
    template_text: "Use the forward difference approximation to estimate the first derivative of the following function: f(x) = [a]x^3 + [b]x^2 + [c]x + [d]. Evaluate the derivative at x = [x] using a step size of h = [h].",
    equation: '(a*(x+h)**3 + b*(x+h)**2 + c*(x+h) + d - (a*x**3 + b*x**2 + c*x + d)) / h',
    variables: [ "a", "b", "c", "d", "x", "h" ],
    answer: nil,
    correct_submissions: 0,
    total_submissions: 0,
    explanation: 'To solve this problem, use the forward difference approximation formula for the first derivative of a function. The formula is (f(x+h) - f(x)) / h.',
    round_decimals: 2,
    variable_ranges: [ [ 1, 25 ], [ 1, 10 ], [ 1, 10 ], [ 1, 100 ], [ 1, 10 ], [ 0.01, 1 ] ],
    variable_decimals: [ 2, 2, 2, 2, 2, 2 ],
    question_kind: "equation"
  },
  {
    topic_id: topics[2].topic_id,
    type_id: types[1].type_id,
    img: nil,
    template_text: "Use the backward difference approximation to estimate the first derivative of the following function: f(x) = [a]x^3 + [b]x^2 + [c]x + [d]. Evaluate the derivative at x = [x] using a step size of h = [h].",
    equation: '(a*x**3 + b*x**2 + c*x + d - (a*(x-h)**3 + b*(x-h)**2 + c*(x-h) + d)) / h',
    variables: [ "a", "b", "c", "d", "x", "h" ],
    answer: nil,
    correct_submissions: 0,
    total_submissions: 0,
    explanation: 'To solve this problem, use the backward difference approximation formula for the first derivative of a function. The formula is (f(x) - f(x-h)) / h.',
    round_decimals: 2,
    variable_ranges: [ [ 1, 25 ], [ 1, 10 ], [ 1, 10 ], [ 1, 100 ], [ 1, 10 ], [ 0.01, 1 ] ],
    variable_decimals: [ 2, 2, 2, 2, 2, 2 ],
    question_kind: "equation"
  },
  {
    topic_id: topics[2].topic_id,
    type_id: types[1].type_id,
    img: nil,
    template_text: "Use the centered difference approximation to estimate the first derivative of the following function: f(x) = [a]x^3 + [b]x^2 + [c]x + [d]. Evaluate the derivative at x = [x] using a step size of h = [h].",
    equation: '(a*(x+h)**3 + b*(x+h)**2 + c*(x+h) + d - (a*(x-h)**3 + b*(x-h)**2 + c*(x-h) + d)) / (2*h)',
    variables: [ "a", "b", "c", "d", "x", "h" ],
    answer: nil,
    correct_submissions: 0,
    total_submissions: 0,
    explanation: 'To solve this problem, use the centered difference approximation formula for the first derivative of a function. The formula is (f(x+h) - f(x-h)) / (2*h).',
    round_decimals: 2,
    variable_ranges: [ [ 1, 25 ], [ 1, 10 ], [ 1, 10 ], [ 1, 100 ], [ 1, 10 ], [ 0.01, 1 ] ],
    variable_decimals: [ 2, 2, 2, 2, 2, 2 ],
    question_kind: "equation"
  },
  {
    topic_id: topics[2].topic_id,
    type_id: types[1].type_id,
    img: nil,
    template_text: "Find the true derivative value of the following function: f(x) = [a]x^3 + [b]x^2 + [c]x + [d]. Evaluate the derivative at x = [x].",
    equation: '3*a*x**2 + 2*b*x + c',
    variables: [ "a", "b", "c", "d", "x" ],
    answer: nil,
    correct_submissions: 0,
    total_submissions: 0,
    explanation: 'To solve this problem, take the derivative of the function f(x) = ax^3 + bx^2 + cx + d. The derivative of this function is 3ax^2 + 2bx + c.',
    round_decimals: 2,
    variable_ranges: [ [ 1, 25 ], [ 1, 10 ], [ 1, 10 ], [ 1, 100 ], [ 1, 10 ], [ 0.01, 1 ] ],
    variable_decimals: [ 2, 2, 2, 2, 2, 2 ],
    question_kind: "equation"
  },
  {
    topic_id: topics[2].topic_id,
    type_id: types[1].type_id,
    img: nil,
    template_text: "A heat exchanger is used to cool a liquid flowing through a pipeline. The temperature of the liquid at one point in the pipeline is measured over time and recorded as the data given. Using the data, calculate the change in temperature with time at point 4 using a first order backward finite difference method. The data is given in the format Point x: (Time (s), Temperature (°C)). Data - Point 1: (10.0, [T1]); Point 2: (10.2, [T2]); Point 3: (10.4, [T3]); Point 4: (10.6, [T4]); Point 5: (10.8, [T5]).",
    equation: '(T4 - T3) / (10.6 - 10.4)',
    variables: [ "T1", "T2", "T3", "T4", "T5" ],
    answer: nil,
    correct_submissions: 0,
    total_submissions: 0,
    explanation: 'To solve this problem, use the backward finite difference method to estimate the change in temperature with time at point 4. The formula is (temperature_4 - temperature_3) / (time_4 - time_3).',
    round_decimals: 2,
    variable_ranges: [ [ 80, 85 ], [ 75, 80 ], [ 70, 75 ], [ 65, 70 ], [ 60, 65 ] ],
    variable_decimals: [ 1, 1, 1, 1, 1 ],
    question_kind: "equation"
  },
  {
    topic_id: topics[3].topic_id,
    type_id: types[1].type_id,
    template_text: "Studies show the average production processing time required to repair an automatic loading machine in a complex food-packaging operation is [mean] minutes with a standard deviation of [std] minutes and follows a normal distribution. If the process is down for [x] minutes or longer, all equipment must be cleaned, with the loss of all product in process. Calculate the probability that the repair takes [x] minutes or longer. Construct a properly labeled distribution with x and z scales.",
    equation: "10.56",
    variables: [ "mean", "std", "x" ],
    answer: nil,
    correct_submissions: 0,
    total_submissions: 0,
    explanation: "First, compute the z-score: z = (x - mean) / std. Then use the your chart to find the corresponding CDF value.",
    round_decimals: 2,
    variable_ranges: [ [ 120, 120 ], [ 4, 4 ], [ 125, 125 ] ],
    variable_decimals: [ 0, 0, 0 ],
    question_kind: "equation"
  },
  {
    topic_id: topics[3].topic_id,
    type_id: types[1].type_id,
    template_text: "The life of a particular type of dry-cell battery is normally distributed with a mean of [mean] days and a standard deviation of [std] days. What fraction of these batteries would be expected to survive beyond [x] days?",
    equation: "6.68",
    variables: [ "mean", "std", "x" ],
    answer: nil,
    correct_submissions: 0,
    total_submissions: 0,
    explanation: "Calculate the z-score: z = (x - mean) / std. Then use the your chart to find the corresponding CDF value.",
    round_decimals: 2,
    variable_ranges: [ [ 600, 600 ], [ 60, 60 ], [ 690, 690 ] ],
    variable_decimals: [ 0, 0, 0 ],
    question_kind: "equation"
  },
  {
    topic_id: topics[3].topic_id,
    type_id: types[1].type_id,
    template_text: "The life of a particular type of dry-cell battery is normally distributed with a mean of [mean] days and a standard deviation of [std] days. What fraction of these batteries would be expected to fail before [x] days?",
    equation: "22.66",
    variables: [ "mean", "std", "x" ],
    answer: nil,
    correct_submissions: 0,
    total_submissions: 0,
    explanation: "Calculate the z-score: z = (x - mean) / std. Then use the your chart to find the corresponding CDF value.",
    round_decimals: 2,
    variable_ranges: [ [ 600, 600 ], [ 60, 60 ], [ 555, 555 ] ],
    variable_decimals: [ 0, 0, 0 ],
    question_kind: "equation"
  },
  {
    topic_id: topics[3].topic_id,
    type_id: types[1].type_id,
    template_text: "The heights of a population of adults are normally distributed with a mean of [mean] cm and a standard deviation of [std] cm. What is the probability (%) that a randomly selected adult is shorter than [x] cm? You should use the provided z-tables. Your answer should be a number between 0.0 and 100.0.",
    equation: "15.87",
    variables: [ "mean", "std", "x" ],
    answer: nil,
    correct_submissions: 0,
    total_submissions: 0,
    explanation: "Calculate the z-score: z = (x - mean) / std. Then use the your chart to find the corresponding CDF value.",
    round_decimals: 2,
    variable_ranges: [ [ 160, 160 ], [ 5, 5 ], [ 155, 155 ] ],
    variable_decimals: [ 0, 0, 0 ],
    question_kind: "equation"
  },
  {
    topic_id: topics[3].topic_id,
    type_id: types[1].type_id,
    template_text: "The monthly salaries of employees in a company are normally distributed with a mean of [mean] and a standard deviation of [std]. What is the probability (%) that a randomly selected employee earns more than [x] per month? You should use the provided z-tables. Your answer should be a number between 0.0 and 100.0.",
    equation: "15.87",
    variables: [ "mean", "std", "x" ],
    answer: nil,
    correct_submissions: 0,
    total_submissions: 0,
    explanation: "Calculate the z-score: z = (x - mean) / std. Then use the your chart to find the corresponding CDF value.",
    round_decimals: 2,
    variable_ranges: [ [ 4000, 4000 ], [ 500, 500 ], [ 4500, 4500 ] ],
    variable_decimals: [ 0, 0, 0 ],
    question_kind: "equation"
  },
  {
    topic_id: topics[4].topic_id,
    type_id: types[1].type_id,
    template_text: "The life in hours of a 75-W light bulb is known to be approximately normally distributed, with a standard deviation of [sigma] hours. A random sample of [n] bulbs has a mean life of [mean] hours. Find the lower bound of a 95% confidence interval for the mean of all bulbs.",
    equation: "mean - 2.055*(sigma/(n**(1/2.0)))",
    variables: [ "mean", "sigma", "n" ],
    answer: nil,
    correct_submissions: 0,
    total_submissions: 0,
    explanation: "For a 95% confidence interval with a known standard deviation, use the formula: x̄ ± 1.96*(σ/√n). The lower bound is x̄ - 1.96*(σ/√n).",
    round_decimals: 2,
    variable_ranges: [ [ 900, 1500 ], [ 20, 30 ], [ 15, 25 ] ],
    variable_decimals: [ 0, 0, 0 ],
    question_kind: "equation"
  },
  {
    topic_id: topics[4].topic_id,
    type_id: types[1].type_id,
    template_text: "The life in hours of a 75-W light bulb is known to be approximately normally distributed, with a standard deviation of [sigma] hours. A random sample of [n] bulbs has a mean life of [mean] hours. Find the upper bound of a 95% confidence interval for the mean of all bulbs.",
    equation: "mean + 1.96*(sigma/(n**(1/2.0)))",
    variables: [ "mean", "sigma", "n" ],
    answer: nil,
    correct_submissions: 0,
    total_submissions: 0,
    explanation: "For a 95% confidence interval with a known standard deviation, use the formula: x̄ ± 1.96*(σ/√n). The upper bound is x̄ + 1.96*(σ/√n).",
    round_decimals: 2,
    variable_ranges: [ [ 900, 1500 ], [ 20, 30 ], [ 15, 25 ] ],
    variable_decimals: [ 0, 0, 0 ],
    question_kind: "equation"
  },
  {
    topic_id: topics[4].topic_id,
    type_id: types[1].type_id,
    template_text: "A manufacturer produces piston rings for an automobile engine. It is known that ring diameter is approximately normally distributed and has a standard deviation of [sigma] mm. A random sample of [n] rings has a mean diameter of [mean] mm. Construct a 99% confidence interval on the mean piston ring diameter. What is the range between boundaries?",
    equation: "2*2.575*sigma/(n**(1/2.0))",
    variables: [ "mean", "sigma", "n" ],
    answer: nil,
    correct_submissions: 0,
    total_submissions: 0,
    explanation: "For a 99% confidence interval, use z = 2.575. The margin of error is calculated as 2.575*(σ/√n). The range between boundaries is 2*margin of error.",
    round_decimals: 4,
    variable_ranges: [ [ 50, 100 ], [ 0.001, 0.005 ], [ 15, 25 ] ],
    variable_decimals: [ 3, 3, 0 ],
    question_kind: "equation"
  },
  {
    topic_id: topics[4].topic_id,
    type_id: types[1].type_id,
    template_text: "A cereal machine in the manufacturing plant is regulated such that it fills each box in a manner that approximates a normal distribution with a standard deviation of [sigma] oz. The guiding metric is a 96% confidence interval for the mean of all boxes. Today we pulled a random sample of [n] cereal boxes and measured an average content of [mean] oz. Find the lower boundary of the confidence interval.",
    equation: "mean - 2.055*(sigma/(n**(1/2.0)))",
    variables: [ "mean", "sigma", "n" ],
    answer: nil,
    correct_submissions: 0,
    total_submissions: 0,
    explanation: "For a 96% confidence interval, the z-value is approximately 2.055. The lower boundary is computed as mean - z*(sigma/√n).",
    round_decimals: 3,
    variable_ranges: [ [ 20, 30 ], [ 0.5, 1.0 ], [ 40, 60 ] ],
    variable_decimals: [ 1, 1, 0 ],
    question_kind: "equation"
  },
  {
    topic_id: topics[4].topic_id,
    type_id: types[1].type_id,
    template_text: "A cereal machine in the manufacturing plant is regulated such that it fills each box in a manner that approximates a normal distribution with a standard deviation of [sigma] oz. The guiding metric is a 96% confidence interval for the mean of all boxes. Today we pulled a random sample of [n] cereal boxes and measured an average content of [mean] oz. Find the upper boundary of the confidence interval.",
    equation: "mean + 2.055*(sigma/(n**(1/2.0)))",
    variables: [ "mean", "sigma", "n" ],
    answer: nil,
    correct_submissions: 0,
    total_submissions: 0,
    explanation: "For a 96% confidence interval, the z-value is approximately 2.055. The upper boundary is computed as mean + z*(sigma/√n).",
    round_decimals: 3,
    variable_ranges: [ [ 20, 30 ], [ 0.5, 1.0 ], [ 40, 60 ] ],
    variable_decimals: [ 1, 1, 0 ],
    question_kind: "equation"
  },
  {
    topic_id: topics[5].topic_id,
    type_id: types[1].type_id,
    template_text: "A roller coaster with mass [m] kg starts from rest at the top of a hill with a height of [h] meters and travels a total distance of [d] m to the bottom. If the air resistance (drag force) is [F] N, calculate the velocity (in m/s) of the roller coaster just before it reaches the bottom of the hill.",
    equation: "(2*((m*9.8*h) - (F*d))/m)**0.5",
    variables: [ "m", "h", "d", "F" ],
    answer: nil,
    correct_submissions: 0,
    total_submissions: 0,
    explanation: "Using energy conservation: the potential energy m*g*h is partially lost to work done against air resistance (F*d), leaving (1/2)*m*v^2 = m*g*h - F*d. Solving for v yields v = sqrt(2*(m*g*h - F*d)/m).",
    round_decimals: 2,
    variable_ranges: [ [ 2000, 2400 ], [ 20, 40 ], [ 50, 70 ], [ 4750, 5250 ] ],
    variable_decimals: [ 0, 0, 0, 0 ],
    question_kind: "equation"
  },
  {
    topic_id: topics[5].topic_id,
    type_id: types[1].type_id,
    template_text: "Blackberries and sugar are combined in a 60:40 mass ratio to make jam. Blackberries are 70% water and 30% solids, while sugar is 100% solids, and the mixture is heated to remove water until the final solids content is 75%. If blackberries cost $[b] per kg and sugar costs $[s]/kg, what is the cost of the blackberries in $ required to make 1 kg of jam?",
    equation: "75/(30+100*40/60.0)*b",
    variables: [ "b", "s" ],
    answer: nil,
    correct_submissions: 0,
    total_submissions: 0,
    explanation: "To find the cost of blackberries required to make 1kg of jam, use the equation cost = (75/(30+100*40/60))*b, where b is the cost of blackberries per kg.",
    round_decimals: 2,
    variable_ranges: [ [ 1, 2 ], [ 0.10, 0.20 ] ],
    variable_decimals: [ 2, 2 ],
    question_kind: "equation"
  },
  {
    topic_id: topics[5].topic_id,
    type_id: types[1].type_id,
    template_text: "Blackberries and sugar are combined in a 60:40 mass ratio to make jam. Blackberries are 70% water and 30% solids, while sugar is 100% solids, and the mixture is heated to remove water until the final solids content is 75%. If blackberries cost $[b] per kg and sugar costs $[s]/kg, what is the cost of the sugar in $ required to make 1 kg of jam?",
    equation: "75/(30+100*40/60.0)*4/60.0*s",
    variables: [ "b", "s" ],
    answer: nil,
    correct_submissions: 0,
    total_submissions: 0,
    explanation: "To find the cost of sugar required to make 1kg of jam, use the equation cost = (75/(30+100*40/60))*4/60*s, where s is the cost of sugar per kg.",
    round_decimals: 3,
    variable_ranges: [ [ 1, 2 ], [ 0.10, 0.20 ] ],
    variable_decimals: [ 2, 2 ],
    question_kind: "equation"
  },
  {
    topic_id: topics[1].topic_id,
    type_id: types[1].type_id,
    template_text: "For a simple yo-yo, the speed of the center of mass of the cylinder is given by\nv = 2 * sqrt( g*h / 3)\nwhere h is the descended distance measured in meters and g is the acceleration due to gravity measured in m/s^2. Assume that g is exact.\nFind the fractional uncertainty in speed v if the uncertainty in the measurement of distance is [d]%, that is, the descended distance is h ± 0.0[d]*h meters.\nExpress the fractional uncertainty of the speed as a percentage (that is, a value between 0 and 100%). Do not include the percent symbol.",
    equation: "d/2",
    variables: [ "d" ],
    answer: nil,
    correct_submissions: 0,
    total_submissions: 0,
    explanation: "Speed is given by v = 2 * sqrt(g*h / 3). The fractional uncertainty in speed is given by the partial derivative of v with respect to h, which is (1/2)*sqrt(3/g*h) * (1/h) * (dh/dt). This simplifies to d/2, where d is the percentage uncertainty in h.",
    round_decimals: 1,
    variable_ranges: [ [ 1, 9 ] ],
    variable_decimals: [ 0, 0 ],
    question_kind: "equation"
  },
  {
    topic_id: topics[6].topic_id,
    type_id: types[1].type_id,
    template_text: "In a sprocket-chain system of a bicycle, all points on the chain have the same linear speed.\nDetermine the ratio of the angular speeds of the sprockets (angular speed front / angular speed rear), if the radius of the front sprocket is [r] times the radius of the rear sprocket.",
    equation: "1/r",
    variables: [ "r" ],
    answer: nil,
    correct_submissions: 0,
    total_submissions: 0,
    explanation: "In this system, all points on the the chain travel at the same speed. So the linear speeds must be equal and we get r_f * ω_f = r_r * ω_r. Since r_f is 1[r] times larger thatn r_r we get [r]ω_f = ω_r. to get the ratio we calculate using 1/[r].",
    round_decimals: 3,
    variable_ranges: [ [ 1, 9 ] ],
    variable_decimals: [ 1, 1 ],
    question_kind: "equation"
  },
  {
    topic_id: topics[1].topic_id,
    type_id: types[1].type_id,
    template_text: "The centripetal acceleration of a car rounding a banked curve is given by a = g * tan(θ) where θ is the bank angle measured in degrees. " +
                 "If θ = [theta] ± [theta_error]°, calculate the uncertainty of the centripetal acceleration. " +
                 "Use g = 9.81 m/s² (assume exact value).",
    equation: "9.81 * (1 / Math.cos(theta * Math::PI / 180))**2 * theta_error * (Math::PI / 180)",
    variables: [ "theta", "theta_error" ],
    answer: nil,
    correct_submissions: 0,
    total_submissions: 0,
    explanation: "Use propagation of error: δa = |da/dθ| * δθ. Since a = g * tan(θ), we get da/dθ = g * sec²(θ). Convert θ and δθ to radians before calculation. Final formula: δa = g * sec²(θ) * δθ * (π / 180).",
    round_decimals: 3,
    variable_ranges: [ [ 10.0, 40.0 ], [ 0.5, 2.0 ] ],
    variable_decimals: [ 1, 1 ],
    question_kind: "equation"
  },
  {
    topic_id: topics[8].topic_id,
    type_id: types[1].type_id,
    template_text: "A horizontal lightweight beam ABCD is loaded and supported as follows: " +
                 "- Pin support at A (left end of the beam) " +
                 "- A downward force F = [F] N at point B " +
                 "- A downward force P = [P] N at point C " +
                 "- A roller support at point D, located on an inclined surface at an angle θ = [theta]° from the horizontal " +
                 "- The beam is of uniform length with AB = BC = CD = L/3. " +
                 "Determine the following: " +
                 "1. The magnitude of the reaction force at the roller support D (in N) " +
                 "2. The magnitude of the reaction force at the pin support A (in N) " +
                 "Provide your answer as a comma-separated pair (Ex: 18.4, 19.9).",
    equation: "d = (F * (1.0/3.0) + P * (2.0/3.0)) / Math.cos(theta * Math::PI / 180.0); ax = d * Math.sin(theta * Math::PI / 180.0); ay = F + P - d * Math.cos(theta * Math::PI / 180.0); a = Math.sqrt(ax**2 + ay**2); [d.round(1), a.round(1)].join(', ')",
    variables: [ "F", "P", "theta" ],
    answer: nil,
    correct_submissions: 0,
    total_submissions: 0,
    explanation: "First, use moment equilibrium about A to solve for D: D = (F * 1/3 + P * 2/3) / cos(θ). Then solve for A using: A_x = D * sin(θ), A_y = F + P - D * cos(θ), A = √(A_x² + A_y²).",
    round_decimals: 1,
    variable_ranges: [ [ 18, 25 ], [ 12, 18 ], [ 20, 30 ] ],
    variable_decimals: [ 1, 1, 0 ],
    question_kind: "equation"
  },
  {
    topic_id: topics[6].topic_id,
    type_id: types[1].type_id,
    template_text: "A thin rectangular plate, uniform in both shape and mass, is shown below. It has width a and length b, and rotates about axis z. " +
                  "The moment of inertia at its center of mass is given by I_cm = (1/12) * m * (a^2 + b^2). " +
                  "What is the ratio of the moment of inertia about axis z to the moment of inertia about its center of mass?",
    equation: "4",
    variables: [],
    answer: 4,
    correct_submissions: 0,
    total_submissions: 0,
    explanation: "Use the Parallel Axis Theorem: I_z = I_cm + m*d^2. The axis is offset by d = √[(a/2)^2 + (b/2)^2] → d^2 = (a² + b²)/4. " +
                "So, I_z = (1/12)m(a² + b²) + m(a² + b²)/4 = (1/3)m(a² + b²). The ratio I_z / I_cm = (1/3) / (1/12) = 4.",
    round_decimals: 0,
    variable_ranges: [],
    variable_decimals: [],
    question_kind: "equation"
  }
])

# Optional: AnswerChoices for the multiple choice question
mc_1 = Question.create!({
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
})

mc_2 = Question.create!({
  topic_id: topics[1].topic_id,
  type_id: types[2].type_id,
  template_text: "A snowman wire wreath frame is made of two circles.\nThe uncertainty in the radius of the smaller circle is b, the uncertainty in the radius of the bigger circle is 2b, where b is a positive real number.\nDetermine the uncertainty in the total length of the wire frame.\nAssume that the errors are independent and random. Recall that the circumference of a circle is given by C = 2πr.",
  equation: nil,
  variables: [],
  answer: "2πb*sqrt(5)",
  correct_submissions: 0,
  total_submissions: 0,
  explanation: "The length of the wire is given by L = 2π(b + 2b). Since these are independent, we use the root-sum-squeare method to propogate uncertainty. We find the partial derivative of the length L with respect to eahc radius is 2π, so uncertainty is given by sqrt(2πb)^2 + (4πb)^2 which simplifies to 2πb*sqrt(5).",
  round_decimals: nil,
  variable_ranges: [],
  variable_decimals: [],
  question_kind: "equation"
})

mc_3 = Question.create!({
  topic_id: topics[4].topic_id,
  type_id: types[2].type_id,
  template_text: "Given X ~ N( C, (0.25C)^2)\nthat is, X follows a normal distribution with population mean C and population variance (0.25C)^2,\nwhere C is a positive real number,\ndetermine whether the following inequality is True or False:\nP( X ≤ 0.5C ) ≤ 0.02",
  equation: nil,
  variables: [],
  answer: "False",
  correct_submissions: 0,
  total_submissions: 0,
  explanation: "For variable X that is distributed X ~ N(C, 0.25c)^2 we can find the z-score for 0.5C as z = (0.5C - C) / (0.25C) = -2. The probability of z being less than -2 is approximately 0.0228, which is greater than 0.02, so the statement is false.",
  round_decimals: nil,
  variable_ranges: [],
  variable_decimals: [],
  question_kind: "equation"
})

mc_4 = Question.create!({
  topic_id: topics[4].topic_id,
  type_id: types[2].type_id,
  template_text: "For a normal population with known variance σ^2 (sigma squared), a random sample of n measurements is used to compute a two-sided confidence interval for the population mean. Determine the confidence level, p%, if the width of the confidence interval is\n2 * 1.82 * σ / sqrt(n).\nYou should use the provided z-tables.",
  equation: nil,
  variables: [],
  answer: "93.12%",
  correct_submissions: 0,
  total_submissions: 0,
  explanation: "The two sided confidence interval is given by x +/- z(σ/sqrt(n)). The width of the confidence interval is 2z(σ/sqrt(n)). Given that the width is 2 * 1.82 * σ / sqrt(n), we can find that z = 1.82. Using the z-tables, we find that the confidence level corresponding to z = 1.82 is approximately 93.12%.",
  round_decimals: nil,
  variable_ranges: [],
  variable_decimals: [],
  question_kind: "equation"
})

mc_5 = Question.create!({
  topic_id: topics[6].topic_id,
  type_id: types[2].type_id,
  template_text: "A kid pins a hula hoop with radius r to a wall (that is, the pin goes through the rim of the hula hoop). The kid displaces the hula hoop to the left through an angle theta from its equilibrium position and lets it go. What is the angular speed of the hula hoop when it returns to (goes through) its equilibrium position? Assume that there is no friction.\nHint: The gravitational potential energy associated with the hula hoop is given by\nU = m*g*y_cm\nwhere y_cm is the y-coordinate of the center of mass and m is the mass of the hula hoop.\nIf the acceleration of gravity g is the same at all points on the body, the gravitational potential energy is the same as though all the mass were concentrated at the center of mass of the body.",
  equation: nil,
  variables: [],
  answer: "sqrt(g * (1 - cos(θ)) / r)",
  correct_submissions: 0,
  total_submissions: 0,
  explanation: "When the hula hoop is pinned and displaced at angle θ, the gravitational potential energy is given by U = m*g*y_cm. The center of mass of the hula hoop is at a distance r from the pin. When the hula hoop returns to its equilibrium position, all the potential energy is converted to kinetic energy. The angular speed can be found using conservation of energy: m*g*h = 1/2*m*(r*ω)^2, where h = r(1 - cos(θ)). Solving for ω gives us ω = sqrt(g * (1 - cos(θ)) / r).",
  round_decimals: nil,
  variable_ranges: [],
  variable_decimals: [],
  question_kind: "equation"
})

mc_6 = Question.create!({
  topic_id: topics[7].topic_id,
  type_id: types[2].type_id,
  template_text: "A small mass attached to a spring moves vertically with simple harmonic motion according to the equation\nd^2y/dt^2 = -4π^2y (that is, acceleration = -4 * π * π * y)\nwhere the units are SI.\nDetermine the period of oscillation (in seconds).",
  equation: nil,
  variables: [],
  answer: "1",
  correct_submissions: 0,
  total_submissions: 0,
  explanation: "In simple harmonic motion, the acceleration of the mass is given by a = -ω^2*y which can be compared to the equation given. The angular frequency ω is given by ω = 2π/T, where T is the period of oscillation. From the equation, we can see that ω^2 = 4π^2, so ω = 2π. When solving for T we get 1 second",
  round_decimals: nil,
  variable_ranges: [],
  variable_decimals: [],
  question_kind: "equation"
})

mc_7 = Question.create!({
  topic_id: topics[9].topic_id,
  type_id: types[2].type_id,
  template_text: 'True or False: "Accountability" is imposed externally on an individual by some authority.',
  equation: nil,
  variables: [],
  answer: "False",
  correct_submissions: 0,
  total_submissions: 0,
  explanation: 'Accountability, when defined strictly, is not always externally imposed—it can also be internal, such as self-accountability driven by personal ethics. Therefore, the statement is False.',
  round_decimals: nil,
  variable_ranges: [],
  variable_decimals: [],
  })


mc_8 = Question.create!({
  topic_id: topics[9].topic_id,
  type_id: types[2].type_id,
  template_text: 'True or False: An engineer believes that a condition exists and accepts information that supports the belief but rejects disproving information. This is an example of overconfidence bias.',
  equation: nil,
  variables: [],
  answer: "False",
  correct_submissions: 0,
  total_submissions: 0,
  explanation: 'This is an example of confirmation bias, not overconfidence. Confirmation bias is the tendency to search for, interpret, and remember information that confirms one’s preexisting beliefs.',
  round_decimals: nil,
  variable_ranges: [],
  variable_decimals: [],
})


AnswerChoice.create!([
  { question_id: mc_1.id, choice_text: "Joule", correct: false },
  { question_id: mc_1.id, choice_text: "Watt", correct: false },
  { question_id: mc_1.id, choice_text: "Newton", correct: true },
  { question_id: mc_1.id, choice_text: "Pascal", correct: false },
  { question_id: mc_2.id, choice_text: "2πb*sqrt(5)", correct: true },
  { question_id: mc_2.id, choice_text: "2π*sqrt(3b)", correct: false },
  { question_id: mc_2.id, choice_text: "b*sqrt(5)", correct: false },
  { question_id: mc_2.id, choice_text: "sqrt(10πb)", correct: false },
  { question_id: mc_3.id, choice_text: "True", correct: false },
  { question_id: mc_3.id, choice_text: "False", correct: true },
  { question_id: mc_4.id, choice_text: "92.67%", correct: false },
  { question_id: mc_4.id, choice_text: "78.12%", correct: false },
  { question_id: mc_4.id, choice_text: "93.12%", correct: true },
  { question_id: mc_4.id, choice_text: "98.61%", correct: false },
  { question_id: mc_5.id, choice_text: "sqrt(g * (1 - sin(θ)) / r)", correct: false },
  { question_id: mc_5.id, choice_text: "sqrt(g * (1 - cos(θ)) / (2*r)", correct: false },
  { question_id: mc_5.id, choice_text: "sqrt(g * (1 - sin(θ)) / (2*r)", correct: false },
  { question_id: mc_5.id, choice_text: "sqrt(g * (1 - cos(θ)) / r)", correct: true },
  { question_id: mc_5.id, choice_text: "sqrt(g * (r * g * (1 - cos(θ))", correct: false },
  { question_id: mc_6.id, choice_text: "1", correct: true },
  { question_id: mc_6.id, choice_text: "4π", correct: false },
  { question_id: mc_6.id, choice_text: "4", correct: false },
  { question_id: mc_6.id, choice_text: "0.25π", correct: false },
  { question_id: mc_7.id, choice_text: "True", correct: false },
  { question_id: mc_7.id, choice_text: "False", correct: true },
  { question_id: mc_8.id, choice_text: "True", correct: false },
  { question_id: mc_8.id, choice_text: "False", correct: true }
])
# {
#   topic_id: topics[3].topic_id,
#   type_id: types[1].type_id,
#   img: nil,
#   template_text:
# }
