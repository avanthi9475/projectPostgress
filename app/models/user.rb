class User < ApplicationRecord
    has_many :complaints, dependent: :destroy
end
