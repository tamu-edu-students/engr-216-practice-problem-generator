class User < ApplicationRecord
  enum :role, { student: 0, instructor: 1, admin: 2 }

  has_many :submissions, dependent: :destroy
  has_many :questions, through: :submissions, source: :question

  belongs_to :instructor, class_name: "User", optional: true

  validates :first_name, :last_name, :email, presence: true
  validates :email, uniqueness: true

  def full_name
    "#{first_name} #{last_name}"
  end

  def update_user_submissions(correct)
    increment!(:total_submissions)
    increment!(:correct_submissions) if correct
  end

  def total_accuracy
  end

  def submissions_by_topic
  end

end
