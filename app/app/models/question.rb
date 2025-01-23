class Question < ApplicationRecord
  belongs_to :topic
  belongs_to :type
end
