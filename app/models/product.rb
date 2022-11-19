class ImageUrlValidator < ActiveModel::EachValidator
  IMAGE_URL_REGEX = /\Ahttps?:\/\/[\S]+\.(gif|jpg|png)\z/

  def validate_each(record, attribute, value)
    record.errors.add attribute, "has invalid Image URL" if value !~ IMAGE_URL_REGEX
  end
end


class Product < ApplicationRecord
  PERMALINK_REGEX = /\A[a-z0-9-]+\z/i.freeze
  DESCRIPTION_WORDS_REGEX = /[a-z0-9]+/i.freeze

  has_many :line_items
  # specifying indirect relationship through another entity
  has_many :orders, through: :line_items

  before_destroy :ensure_not_referenced_by_any_line_item

  # Adding validation related to Product text field for not being empty
  validates :title, :description, :image_url,:price,:discount_price, presence: true

  validates :discount_price,
  numericality: { greater_than: 0 },
  allow_blank: true

  # Adding validation related to price being positive number
  validates :price, numericality: { greater_than_or_equal_to: 0.01 },comparison: { 
    greater_than: :discount_price,
    message: 'must be greater than discount price'
  }, allow_blank: true

  # Validation for title being unique
  validates :title, uniqueness: true

  validates :permalink , uniqueness: true, format: {with: PERMALINK_REGEX, message: "Permalink -  no special character and no space allowed"}

  validates :permalink_length_without_hyphen, comparison: { greater_than_or_equal_to: 3}

  validates_length_of :words_in_description, 
  in: 5..10,
  too_short: 'must be more than 5',
  too_long: 'must be less than 10',
  allow_blank: true

  validates :image_url, 
  image_url: true,
  allow_blank: true

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

  private def words_in_description
    description.scan(DESCRIPTION_WORDS_REGEX)
  end

  private def permalink_length_without_hyphen
    permalink.split('-').length
  end
end

