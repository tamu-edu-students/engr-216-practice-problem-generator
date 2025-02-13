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
  { topic_id: 1, topic_name: "Statistical methods (average, standard deviation)" },
  { topic_id: 2, topic_name: "Accuracy and precision of measurements, error propagation" },
  { topic_id: 3, topic_name: "Velocity" },
  { topic_id: 4, topic_name: "Acceleration" },
  { topic_id: 5, topic_name: "Equations of motion" },
  { topic_id: 6, topic_name: "Application of Newton’s laws" },
  { topic_id: 7, topic_name: "Static and kinetic friction" },
  { topic_id: 8, topic_name: "Impulse" },
  { topic_id: 9, topic_name: "Kinetic energy" },
  { topic_id: 10, topic_name: "Conservation of momentum" },
  { topic_id: 11, topic_name: "Rotational motion" },
  { topic_id: 12, topic_name: "Center of mass, moment of inertia, and angular momentum" },
  { topic_id: 13, topic_name: "Force transmission" }
])

types = Type.create([
  { type_id: 1, type_name: "Definition" },
  { type_id: 2, type_name: "Multiple choice" },
  { type_id: 3, type_name: "Free response" }
])

questions = Question.create([
  {
    topic_id: topics[0].topic_id,  # Use topic_id instead of topic
    type_id: types[1].type_id,  # Use type_id instead of type
    img: nil,
    template_text: 'Find the average of the array [\( a \), \( b \), \( c \), \( d \), \( e \)]',
    equation: '(a + b + c + d + e) / 5',
    variables: [ "a", "b", "c", "d", "e" ],
    answer: nil,
    correct_submissions: 0,
    total_submissions: 0
  },
  {
    topic_id: topics[1].topic_id,  # Use topic_id instead of topic
    type_id: types[0].type_id,  # Use type_id instead of type
    img: nil,
    template_text: 'Define the term "accuracy" in the context of measurements.',
    equation: nil,
    variables: [],
    answer: 'Accuracy refers to how close a measured value is to the true value of the quantity being measured.',
    correct_submissions: 0,
    total_submissions: 0
  },
  {
    topic_id: topics[2].topic_id,  # Use topic_id instead of topic, id = 3
    type_id: types[2].type_id,  # Use type_id instead of type, id = 3
    img: "https://science4fun.info/wp-content/uploads/2017/02/velocity-of-car.jpg",
    template_text: 'A car starts with an initial velocity of \( u \) and accelerates at a constant rate \( a \) for a time \( t \). Calculate the final velocity, v, of the car.',
    equation: 'u + a * t',
    variables: [ "u", "a", "t" ],
    answer: nil,
    correct_submissions: 0,
    total_submissions: 0
  }
])

User.find_or_create_by!(email: "instructorA@tamu.edu") do |user|
  user.first_name = "Philip"
  user.last_name = "Ritchey"
  user.role = 1
end

User.find_or_create_by!(email: "instructorB@tamu.edu") do |user|
  user.first_name = "Robert"
  user.last_name = "Lightfoot"
  user.role = 1
end
