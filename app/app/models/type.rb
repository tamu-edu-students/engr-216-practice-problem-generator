class Type < ApplicationRecord
    validates :type_id, :type_name, presence: true
    validates :type_id, uniqueness: true
end
