module ProductsHelper
  def format_html_to_overview(html, **truncate_args)
    truncate(strip_tags(html), truncate_args)
  end

  def generate_image_url(image)
    image.present? ? rails_blob_path(image, disposition: "attachment") : "default_product.png"
  end

  def generate_ratings
    (0..5).step(0.5).to_a
  end

  def average_rating(product)
    product.ratings.average(:rating) || 'Add Rating'
  end

  def current_product_rating_by_user(ratings,current_user)
    ratings.find { |rating| rating.user_id == current_user.id}.try(:rating) || 0
  end
end
