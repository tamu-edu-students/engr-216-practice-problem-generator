require "rails_helper"

RSpec.describe User, type: :model do
  let(:user) {User.create!(first_name: "Johnny", last_name: "Manziel", email: "test@tamu.edu")}
  let(:instructor) {User.create!(first_name: "Paul", last_name: "Taele", email: "prof@tamu.edu", role: "instructor")}
  let(:question) {Question.create!(topic_id: 1, type_id: 1, template_text: "TEST QUESTION")}

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
end
