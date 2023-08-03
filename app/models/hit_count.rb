class HitCount < ApplicationRecord
    belongs_to :user
    scope :total_hit_count, -> { sum('count')}
end
