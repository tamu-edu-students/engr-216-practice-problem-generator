class User < ApplicationRecord
  enum :role, { student: 0, instructor: 1 }

  belongs_to :instructor, class_name: "User", optional: true

  validates :first_name, :last_name, :email, presence: true
  validates :email, uniqueness: true

  def full_name
    
    "#{first_name} #{last_name}"
  end
end
