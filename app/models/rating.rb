class Rating < ApplicationRecord
    belongs_to :user
    belongs_to :product

    validates :rating, numericality: {in: 0.0..5.0, message: 'Must be between 0 and 5'}
end
