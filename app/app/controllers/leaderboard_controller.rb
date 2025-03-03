class LeaderboardController < ApplicationController
    def leaderboard
        @students = User.where(role: "student").order(correct_submissions: :desc)
        if current_user && current_user.role == "student"
            @rank = @students.index(current_user)
        end
    end
end
