class Submission < ApplicationRecord
  belongs_to :user
  belongs_to :question

  after_create :update_user_stats

  validates :correct, inclusion: {in: [true, false]}
  
  def update_user_stats
    return unless user

    user.increment!(:total_submissions)
    user.increment!(:correct_submissions) if correct
  end
  
end