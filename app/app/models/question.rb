class Question < ApplicationRecord
  belongs_to :topic
  belongs_to :type

  has_many :submissions, dependent: :destroy
  has_many :users, through: :submissions

  validates :topic_id, :type_id, :template_text, presence: true
  validates :template_text, length: { minimum: 5 }
end
