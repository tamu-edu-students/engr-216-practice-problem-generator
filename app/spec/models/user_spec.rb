require "rails_helper"

RSpec.describe User, type: :model do
  let(:user) {User.create!(first_name: "Johnny", last_name: "Manziel", email: "test@tamu.edu")}
  let(:other_user) {User.create!(first_name: "Mike", last_name: "Evans", email: "mevans@tamu.edu")}

  describe "valid information" do
    it "is valid" do
      expect(user).to be_valid
    end

    it "is invalid without a first name" do
      user.first_name = nil;
      expect(user).not_to be_valid
    end

    it "is invalid without a last name" do
      user.last_name = nil;
      expect(user).not_to be_valid
    end

    it "is invalid without an email" do
      user.email = nil
      expect(user).to_not be_valid
    end

    it "is invalid with a duplicate email" do
      user.email = "test@tamu.edu"
      new_student = User.create(first_name: "John", last_name: "Doe", email: "test@tamu.edu")
      expect(new_student).to_not be_valid
    end

    it "defaults role to student" do
      expect(user.role).to eq("student")
    end
  end

  describe "table associations" do
    it { is_expected.to have_many(:submissions).dependent(:destroy)}
    it { is_expected.to have_many(:questions).through(:submissions)}
    it { is_expected.to belong_to(:instructor).optional}
  end

  describe "#full_name" do
    it "returns full name correctly" do
      expect(user.full_name).to eq("Johnny Manziel")
    end
  end

  describe "#update_user_submissions" do
    it "increments total submissions" do
      expect { user.update_user_submissions(false) }.to change { user.total_submissions }.by(1)
    end

    it "increments correct submissions when correct" do
      expect { user.update_user_submissions(true) }.to change { user.correct_submissions }.by(1)
    end

    it "does not increment correct submissions when incorrect" do
      expect { user.update_user_submissions(false) }.not_to change { user.correct_submissions }
    end
  end

  describe "#total accuracy" do 
    
    before do
      user.total_submissions = 17
      user.correct_submissions = 12
    end

    it "correctly calculates the percentage of questions answered correctly" do
      expect(user.total_accuracy).to eq(70.59)
    end

    it "correctly handles zero for the total_submissions" do
      user.total_submissions = 0
      user.correct_submissions = 0
      expect(user.total_accuracy).to eq(0)
    end
  end

  describe "#submissions_by_topic" do
    let!(:topics) do
      [
        create(:topic, topic_id: 1, topic_name: "Physics"),
        create(:topic, topic_id: 2, topic_name: "Mathematics"),
        create(:topic, topic_id: 3, topic_name: "Computer Science"),
        create(:topic, topic_id: 4, topic_name: "Biology")
      ]
    end

    let!(:type) {create(:type, type_id: 1, type_name: "Free Response")}

    # Create a question for each topic
    let!(:questions) do
      topics.map do |topic|
        [
          Question.create!(topic: topic, type: type, template_text: "Sample Question 1"),
          Question.create!(topic: topic, type: type, template_text: "Sample Question 2"),
          Question.create!(topic: topic, type: type, template_text: "Sample Question 3")
        ]
      end.flatten
    end

    context "when there are many submissions" do
      before do
        30.times do
          question = questions.sample
          correct = [true, false].sample
          Submission.create!(user: user, question: question, correct: correct)
        end
      end

      it "groups submissions by submitted topics and counts correct answers" do
        sorted_submissions = user.submissions_by_topic

        expect(sorted_submissions.keys).to match_array(topics.map(&:topic_name))

        topics.each do |topic|
          topic_submissions = sorted_submissions[topic.topic_name]
          expect(topic_submissions[:total_submissions]).to be > 0
          expect(topic_submissions[:correct_submissions]).to be_between(0, topic_submissions[:total_submissions])
        end
      end
    end

    context "when there are less submissions" do
      before do
        # Explicitly create 10 submissions with known values
        [
          { topic: topics[0], correct: true },
          { topic: topics[0], correct: false },
          { topic: topics[1], correct: true },
          { topic: topics[1], correct: true },
          { topic: topics[1], correct: false },
          { topic: topics[2], correct: false },
          { topic: topics[2], correct: false },
          { topic: topics[2], correct: true },
          { topic: topics[3], correct: true },
          { topic: topics[3], correct: false }
        ].each do |entry|
          question = questions.find { |q| q.topic == entry[:topic] } # Pick a question from the given topic
          Submission.create!(user: user, question: question, correct: entry[:correct])
        end
      end

      it "groups submissions by submitted topics and counts correct answers" do
        sorted_submission = user.submissions_by_topic

        expected_results = {
          "Physics" => { total_submissions: 2, correct_submissions: 1, accuracy: 50.0 },
          "Mathematics" => { total_submissions: 3, correct_submissions: 2, accuracy: 66.67 },
          "Computer Science" => { total_submissions: 3, correct_submissions: 1, accuracy: 33.33 },
          "Biology" => { total_submissions: 2, correct_submissions: 1, accuracy: 50.0 }
        }

        expected_results.each do |topic_name, stats|
          received_stats = sorted_submission[topic_name]
          
          expect(received_stats[:total_submissions]).to eq (stats[:total_submissions])
          expect(received_stats[:correct_submissions]).to eq (stats[:correct_submissions])
          expect(received_stats[:accuracy]).to eq (stats[:accuracy])
        end
      end
    end

    context "when there are no submissions for a user" do
      it "returns empty" do
        expect(user.submissions_by_topic).to eq({})
      end

      it "does not use other users submissions" do
        q = Question.create!(topic: topics[0], type: type, template_text: "Sample Question")
        Submission.create!(user: other_user, question: q, correct: true)
        expect(user.submissions_by_topic).to eq({})
      end
    end
  end
end
