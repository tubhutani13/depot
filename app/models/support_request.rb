# Will store received emails on Support route
class SupportRequest < ApplicationRecord
  belongs_to :order, optional: true

  # Adding Action Text support
  has_rich_text :response
end
