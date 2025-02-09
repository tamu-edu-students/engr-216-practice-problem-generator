class Submission < ApplicationRecord
  belongs_to :user
  belongs_to :question

  validates :correct, presence: true
end