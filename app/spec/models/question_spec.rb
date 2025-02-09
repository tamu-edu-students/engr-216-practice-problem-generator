require "rails_helper"

RSpec.describe User, type: :model do
  let(:topic) { Topic.create!(topic_id: 1, topic_name: "TEST TOPIC") }
  let(:type) { Type.create!(type_id: 1, type_name: "TEST TYPE") }
  let(:question) { Question.create!(topic_id: topic.id, type_id: type.id, template_text: "TEST QUESTION") }

  describe "valid information" do
    it "is valid" do
      expect(question).to be_valid
    end

    it "is invalid without a topic_id" do
      question.topic_id = nil
      expect(question).to_not be_valid 
    end

    it "is invalid without a type_id" do
      question.type_id = nil
      expect(question).to_not be_valid 
    end

    it "is invalid without a template_text" do
      question.template_text = nil
      expect(question).to_not be_valid 
    end

    it "is invalid with a short template_text" do
      question.template_text = "Why"
      expect(question).to_not be_valid
    end
  end

  describe "table associations" do
    it { is_expected.to have_many(:submissions).dependent(:destroy)}
    it { is_expected.to have_many(:users).through(:submissions)}

    it "belongs to a topic" do
      expect(question.topic).to eq(topic)
    end

    it "belongs to a type" do
      expect(question.type).to eq(type)
    end
  end

end
