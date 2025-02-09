require "rails_helper"

RSpec.describe Submission, type: :model do
  let!(:user) { User.create!(first_name: "Test", last_name: "User", email: "test@tamu.edu")}
  let!(:topic) { Topic.create!(topic_id: 1, topic_name: "TEST TOPIC") }
  let!(:type) { Type.create!(type_id: 1, type_name: "TEST TYPE") }
  let(:question) { Question.create!(topic: topic, type: type, template_text: "TEST QUESTION")}
  let!(:submission) { Submission.create!(user: user, question: question, correct: true) }

  describe "valid information" do
    it "is valid with a user, question, and correct value" do
      expect(submission).to be_valid
    end

    it "is invalid without a user" do
      submission.user = nil
      expect(submission).not_to be_valid
    end

    it "is invalid without a question" do
      submission.question = nil
      expect(submission).not_to be_valid
    end

    it "is invalid without a value for 'correct'" do
      submission.correct = nil
      expect(submission).not_to be_valid
    end
  end

  describe "table associations" do
    it {is_expected.to belong_to(:user)}
    it {is_expected.to belong_to(:question)}
  end

end
