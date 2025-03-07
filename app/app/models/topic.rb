class Topic < ApplicationRecord
    has_many :questions
    validates :topic_id, :topic_name, presence: true
    validates :topic_id, uniqueness: true
end
