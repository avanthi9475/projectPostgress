class Officer < ApplicationRecord
    has_many :complaints, dependent: :destroy
end
