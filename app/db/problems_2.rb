# 11.1
Question.create!(
  topic_id: 6, 
  type_id: 2, 
  template_text: "A mass-spring system with a damper has mass [m] kg, spring constant [k] N/m, and damping coefficient [b] Ns/m. Is the system underdamped, critically damped, or overdamped?",
  equation: "((b**2)/(4*m**2) - k/m)",
  variables: ["m", "k", "b"],
  variable_ranges: [[0.4, 1.0], [50, 100], [8, 12]],
  variable_decimals: [2, 0, 0],
  answer: nil,
  correct_submissions: 0,
  total_submissions: 0,
  explanation: "Compare β² = (b²)/(4m²) and ω₀² = k/m. If β² - ω₀² > 0 → overdamped; = 0 → critically damped; < 0 → underdamped.",
  round_decimals: 2,
  question_kind: "equation"
)

# 11.2a
Question.create!(
  topic_id: 6,
  type_id: 2,
  template_text: "What is the period of a [L] m long simple pendulum swinging on the Moon? The Moon's gravity is [g_moon] m/s².",
  equation: "2 * Math::PI * Math.sqrt(L / g_moon)",
  variables: ["L", "g_moon"],
  variable_ranges: [[0.5, 2.0], [1.5, 1.7]],
  variable_decimals: [2, 3],
  answer: nil,
  correct_submissions: 0,
  total_submissions: 0,
  explanation: "Use the formula T = 2π√(L/g). Substitute the Moon's gravity to calculate the period.",
  round_decimals: 2,
  question_kind: "equation"
)

# 11.2b
Question.create!(
  topic_id: 6,
  type_id: 2,
  template_text: "What is the period of a [L] m long simple pendulum swinging on Mars? The gravity on Mars is [g_mars] m/s².",
  equation: "2 * Math::PI * Math.sqrt(L / g_mars)",
  variables: ["L", "g_mars"],
  variable_ranges: [[0.5, 2.0], [3.6, 3.8]],
  variable_decimals: [2, 3],
  answer: nil,
  correct_submissions: 0,
  total_submissions: 0,
  explanation: "Use the formula T = 2π√(L/g). Substitute Mars’ gravity to find the period.",
  round_decimals: 2,
  question_kind: "equation"
)

# 11.3a
Question.create!(
  topic_id: 6,
  type_id: 2,
  template_text: "A grad student operates a piezo fan with amplitude [A] m at a frequency of 46 Hz. What is the maximum velocity of the tip of the fan?",
  equation: "2 * Math::PI * A * 46",
  variables: ["A"],
  variable_ranges: [[0.015, 0.03]],
  variable_decimals: [4],
  answer: nil,
  correct_submissions: 0,
  total_submissions: 0,
  explanation: "Use v_max = 2πAf, with f = 46 Hz. Convert amplitude from mm to meters if needed.",
  round_decimals: 2,
  question_kind: "equation"
)

# 11.3b
Question.create!(
  topic_id: 6,
  type_id: 2,
  template_text: "A grad student operates a piezo fan with amplitude [A] m at a frequency of 261.6 Hz. What is the maximum velocity of the tip of the fan?",
  equation: "2 * Math::PI * A * 261.6",
  variables: ["A"],
  variable_ranges: [[0.015, 0.03]],
  variable_decimals: [4],
  answer: nil,
  correct_submissions: 0,
  total_submissions: 0,
  explanation: "Use v_max = 2πAf, with f = 261.6 Hz. Convert amplitude from mm to meters if needed.",
  round_decimals: 2,
  question_kind: "equation"
)

# 8.1
Question.create!(
  topic_id: 6,
  type_id: 2,
  template_text: "A [m_b] g bullet moving at [v_bi] m/s strikes a [m_k] g wooden block at rest on a frictionless surface. The bullet emerges traveling in the same direction with its speed reduced to [v_bf] m/s. What is the resulting speed of the block?",
  equation: "(m_b * (v_bi - v_bf)) / m_k",
  variables: ["m_b", "v_bi", "m_k", "v_bf"],
  variable_ranges: [[4.0, 6.0], [600, 700], [650, 750], [400, 450]],
  variable_decimals: [2, 0, 0, 0],
  answer: nil,
  correct_submissions: 0,
  total_submissions: 0,
  explanation: "Use conservation of momentum: initial momentum = final momentum. Solve for v_kf: v_kf = m_b (v_bi - v_bf) / m_k. Convert masses from grams to kg if using SI units.",
  round_decimals: 2,
  question_kind: "equation"
)

# 8.2
Question.create!(
  topic_id: 6,
  type_id: 2,
  template_text: "An electron undergoes a one-dimensional elastic collision with an initially stationary hydrogen atom. What percentage of the electron's initial kinetic energy is transferred to the hydrogen atom? The hydrogen atom's mass is [r] times the mass of the electron.",
  equation: "(0.5 * r * ((2.0 / (1.0 + r))**2)) * 100",
  variables: ["r"],
  variable_ranges: [[1830, 1850]],
  variable_decimals: [0],
  answer: nil,
  correct_submissions: 0,
  total_submissions: 0,
  explanation: "Use conservation of kinetic energy and momentum for elastic collisions. Final expression: %KE transferred = 0.5 * r * (2 / (1 + r))² * 100.",
  round_decimals: 2,
  question_kind: "equation"
)

# 8.4
Question.create!(
  topic_id: 6,
  type_id: 2,
  template_text: "A soccer ball with mass [m_s] kg is held above a yoga ball with mass [m_y] kg and dropped from a height of [h] m. When the two balls hit the floor, the yoga ball transfers all its momentum to the soccer ball. How high does the soccer ball bounce into the air?",
  equation: "((m_s + m_y) / m_s)**2 * h",
  variables: ["m_s", "m_y", "h"],
  variable_ranges: [[0.4, 0.6], [0.8, 1.2], [0.25, 0.35]],
  variable_decimals: [2, 2, 2],
  answer: nil,
  correct_submissions: 0,
  total_submissions: 0,
  explanation: "Use conservation of momentum followed by conversion to potential energy: h_s = ((m_s + m_y)/m_s)² * h.",
  round_decimals: 2,
  question_kind: "equation"
)

# 8.3a
Question.create!(
  topic_id: 6,
  type_id: 2,
  template_text: "Two 2.0 kg bodies A and B collide. Their initial velocities are v_A = [vA_x]î + [vA_y]ĵ m/s and v_B = [vB_x]î + [vB_y]ĵ m/s. After the collision, body A has velocity v_Af = [vAf_x]î + [vAf_y]ĵ m/s. What is the final velocity of body B?",
  equation: "[vA_x + vB_x - vAf_x, vA_y + vB_y - vAf_y]",
  variables: ["vA_x", "vA_y", "vB_x", "vB_y", "vAf_x", "vAf_y"],
  variable_ranges: [[14,16], [29,31], [-11,-9], [4,6], [-6,-4], [19,21]],
  variable_decimals: [1, 1, 1, 1, 1, 1],
  answer: nil,
  correct_submissions: 0,
  total_submissions: 0,
  explanation: "Use vector conservation of momentum: v_A + v_B = v_Af + v_Bf. Rearranged, v_Bf = v_A + v_B - v_Af.",
  round_decimals: 2,
  question_kind: "equation"
)

# 8.3b
Question.create!(
  topic_id: 6,
  type_id: 2,
  template_text: "Two 2.0 kg bodies A and B collide. Their initial velocities are v_A = [vA_x]î + [vA_y]ĵ m/s and v_B = [vB_x]î + [vB_y]ĵ m/s. After the collision, their final velocities are v_Af = [vAf_x]î + [vAf_y]ĵ m/s and v_Bf = [vBf_x]î + [vBf_y]ĵ m/s. How much kinetic energy is lost in the collision?",
  equation: "0.5 * 2 * ((vA_x**2 + vA_y**2) + (vB_x**2 + vB_y**2) - (vAf_x**2 + vAf_y**2) - (vBf_x**2 + vBf_y**2))",
  variables: ["vA_x", "vA_y", "vB_x", "vB_y", "vAf_x", "vAf_y", "vBf_x", "vBf_y"],
  variable_ranges: [[14,16], [29,31], [-11,-9], [4,6], [-6,-4], [19,21], [9,11], [14,16]],
  variable_decimals: [1, 1, 1, 1, 1, 1, 1, 1],
  answer: nil,
  correct_submissions: 0,
  total_submissions: 0,
  explanation: "Kinetic energy lost = total initial KE - total final KE, using KE = 0.5mv² for both objects.",
  round_decimals: 2,
  question_kind: "equation"
)