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
    return 0 if total_submissions.zero?
    (correct_submissions.to_f / total_submissions.to_f * 100.0).round(2)
  end

  def submissions_by_topic
    topic_stats = Hash.new { |hash, key| hash[key] = { total_submissions: 0, correct_submissions: 0, accuracy: 0.0 } }

    submissions.includes(question: :topic).each do |submission|
      topic_name = submission.question&.topic&.topic_name

      topic_stats[topic_name][:total_submissions] += 1
      topic_stats[topic_name][:correct_submissions] += 1 if submission.correct
    end

    topic_stats.each do |topic_name, stats|
      stats[:accuracy] = stats[:total_submissions].zero? ? 0.0 : ((stats[:correct_submissions].to_f / stats[:total_submissions]) * 100).round(2)
    end

    topic_stats
  end
end
