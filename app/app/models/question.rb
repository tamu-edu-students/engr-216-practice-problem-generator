class Question < ApplicationRecord
  belongs_to :topic
  belongs_to :type

  has_many :submissions, dependent: :destroy
  has_many :users, through: :submissions
end
