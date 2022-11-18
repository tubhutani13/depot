class Product < ApplicationRecord
  IMAGE_VALIDATION_REGEX = %r{\.(gif|jpg|png)\z}i.freeze
  has_many :line_items
  # specifying indirect relationship through another entity
  has_many :orders, through: :line_items

  before_destroy :ensure_not_referenced_by_any_line_item

  # Adding validation related to Product text field for not being empty
  validates :title, :description, :image_url, presence: true

  # Adding validation related to price being positive number
  validates :price, numericality: { greater_than_or_equal_to: 0.01 }

  # Validation for title being unique
  validates :title, uniqueness: true

  # Validation of url using regex
  validates :image_url, allow_blank: true, format: {
    with:   IMAGE_VALIDATION_REGEX,
    message: 'must be a URL for GIF, JPG, or PNG image.'
  }

  ## Creating hook method, executed before rails attempt to destory row in database
  private def ensure_not_referenced_by_any_line_item
    # ensure that there are no line items referencing this product
    unless line_items.empty?
      # same object used by validations to store errors
      errors.add(:base, 'Line Items present')

      # If hook method throws abort then row is not destroyed
      throw :abort
    end
  end
end
