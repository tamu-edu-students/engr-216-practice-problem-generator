class Topic < ApplicationRecord
    validates :topic_id, :topic_name, presence: true
    validates :topic_id, uniqueness: true
end
