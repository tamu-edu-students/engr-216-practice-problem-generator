class AnswerChoice < ApplicationRecord
  belongs_to :question

  validates :choice_text, presence: true
  validates :correct, inclusion: { in: [true, false] }
end
