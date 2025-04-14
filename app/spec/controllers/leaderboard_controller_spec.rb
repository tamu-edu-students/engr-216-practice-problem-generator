require 'rails_helper'

RSpec.describe LeaderboardController, type: :controller do
  describe "GET #leaderboard" do
    context "when current_user is a student" do
      let!(:student1) do
        User.create!(
          first_name: "student1",
          last_name: "last",
          email: "student1@tamu.edu",
          role: "student",
          total_submissions: 10,
          correct_submissions: 8
        )
      end

      let!(:student2) do
        User.create!(
          first_name: "student2",
          last_name: "last",
          email: "student2@tamu.edu",
          role: "student",
          total_submissions: 15,
          correct_submissions: 12
        )
      end

      let!(:student3) do
        User.create!(
          first_name: "student3",
          last_name: "last",
          email: "student3@tamu.edu",
          role: "student",
          total_submissions: 7,
          correct_submissions: 5
        )
      end

      before do
        allow(controller).to receive(:current_user).and_return(student1)
        get :leaderboard
      end

      it "assigns students sorted by correct_submissions descending" do
        expect(assigns(:students)).to eq([ student2, student1, student3 ])
      end

      it "assigns @rank as the index of current_user in the students list" do
        expect(assigns(:rank)).to eq(1)
      end

      it "renders the leaderboard template" do
        expect(response).to render_template(:leaderboard)
      end
    end

    context "when current_user is not a student" do
      let!(:instructor) do
        User.create!(
          first_name: "Instructor",
          last_name: "last",
          email: "instructor@tamu.edu",
          role: "instructor",
          total_submissions: 0,
          correct_submissions: 0
        )
      end

      let!(:student) do
        User.create!(
          first_name: "student",
          last_name: "last",
          email: "student@tamu.edu",
          role: "student",
          total_submissions: 5,
          correct_submissions: 3
        )
      end

      before do
        allow(controller).to receive(:current_user).and_return(instructor)
        get :leaderboard
      end

      it "assigns students including the student users" do
        expect(assigns(:students)).to include(student)
      end

      it "does not assign a rank for non-student current_user" do
        expect(assigns(:rank)).to be_nil
      end
    end
  end
end
