class Category < ApplicationRecord
  belongs_to :parent, class_name: 'Category', optional: true
  has_many :sub_categories, class_name: 'Category', foreign_key: 'parent_id', dependent: :destroy
  has_many :products, dependent: :restrict_with_error
  has_many :sub_categories_products, through: :sub_categories, source: :products

  validates :name, presence: true
  validates :name, uniqueness: { scope: :parent_id }, allow_blank: true
  validates :parent, one_level_nesting: true

  scope :root_categories, -> { where(parent_id: nil) }
end
