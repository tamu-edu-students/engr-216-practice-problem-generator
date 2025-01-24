class User < ApplicationRecord
  enum :role, { student: 0, instructor: 1 }

  validates :first_name, :last_name, :email, presence: true
  validates :email, uniqueness: true
end
