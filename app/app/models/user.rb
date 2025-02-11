class User < ApplicationRecord
  enum :role, { student: 0, instructor: 1, admin: 2 }

  def full_name
    "#{first_name} #{last_name}"
  end

  belongs_to :instructor, class_name: "User", optional: true

  validates :first_name, :last_name, :email, presence: true
  validates :email, uniqueness: true
end
