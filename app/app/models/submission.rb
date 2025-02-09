class Submission < ApplicationRecord
  belongs_to :user
  belongs_to :question

  validates :correct, inclusion: {in: [true, false]}
end