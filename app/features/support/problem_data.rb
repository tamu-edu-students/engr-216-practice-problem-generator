Before do
    Topic.create!(topic_id: 1, topic_name: "Velocity") unless Topic.exists?(topic_name: "Velocity")
    Topic.create!(topic_id: 2, topic_name: "Acceleration") unless Topic.exists?(topic_name: "Acceleration")
    Topic.create!(topic_id: 3, topic_name: "Accuracy and precision of measurements, error propagation") unless Topic.exists?(topic_name: "Accuracy and precision of measurements, error propagation")

    Type.create!(type_id: 1, type_name: "Definition") unless Type.exists?(type_name: "Definition")
    Type.create!(type_id: 2, type_name: "Free Response") unless Type.exists?(type_name: "Free Response")
end

# features/support/problem_data.rb

Before do

    student = User.first_or_create!(
      email: "student@tamu.edu",
      first_name: "Test",
      last_name: "Student",
      role: 0
    )
  end
