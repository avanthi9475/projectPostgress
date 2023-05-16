class Status < ApplicationRecord
    belongs_to :statusable, polymorphic: true
end
