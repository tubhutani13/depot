class Product < ApplicationRecord
  belongs_to :category, counter_cache: true
  has_many :line_items
  # specifying indirect relationship through another entity
  has_many :orders, through: :line_items

  before_destroy :ensure_not_referenced_by_any_line_item

  # Adding validation related to Product text field for not being empty
  validates :title, :description, :image_url, :price, :discount_price, presence: true

  validates :discount_price,
            numericality: { greater_than: 0 },
            allow_blank: true

  # Adding validation related to price being positive number
  validates :price, numericality: { greater_than_or_equal_to: 0.01 }, comparison: {
                      greater_than: :discount_price,
                      message: "must be greater than discount price",
                    }, allow_blank: true

  # Validation for title being unique
  validates :title, uniqueness: true

  validates :permalink, uniqueness: true, format: { with: PERMALINK_REGEX, message: "Permalink -  no special character and no space allowed" }

  validates :permalink_length_without_hyphen, comparison: { greater_than_or_equal_to: 3 }

  validates_length_of :words_in_description,
                      in: 5..10,
                      too_short: "must be more than 5",
                      too_long: "must be less than 10",
                      allow_blank: true

  validates :image_url,
            image_url: true,
            allow_blank: true

  before_validation :default_title_value
  before_validation :default_discount_price

  after_create_commit :increment_parent_category_products_count, if: :category_parent_present?
  after_destroy_commit :decrement_parent_category_products_count, if: :category_parent_present?
  scope :enabled_products, -> { where(enabled: true) }
  scope :product_ordered, -> { joins(:line_items).distinct }
  scope :ordered_titles, -> { product_ordered.pluck(:title) }

  private def words_in_description
    description.scan(DESCRIPTION_WORDS_REGEX)
  end

  private def permalink_length_without_hyphen
    permalink.split("-").length
  end

  private def default_title_value
    self.title ||= 'abc'
  end

  private def default_discount_value
    self.discount_price ||= self.price
  end

  private def increment_parent_category_products_count
    category.parent.increment!(:products_count)
  end

  private def decrement_parent_category_products_count
    category.parent.increment!(:products_count)
  end

  private def category_parent_present?
    category.present? && category.parent.present?
  end
end
