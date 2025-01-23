Before do
    Topic.create!(topic_id: 1, topic_name: "Velocity") unless Topic.exists?(topic_name: "Velocity")
    Topic.create!(topic_id: 2, topic_name: "Acceleration") unless Topic.exists?(topic_name: "Acceleration")

    Type.create!(type_id: 1, type_name: "Definition") unless Type.exists?(type_name: "Definition")
    Type.create!(type_id: 2, type_name: "Free Response") unless Type.exists?(type_name: "Free Response")
end