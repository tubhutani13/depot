module ProductsHelper
  def format_html_to_overview(html, **truncate_args)
    truncate(strip_tags(html), truncate_args)
  end

  def generate_image_url(image)
    image.present? ? rails_blob_path(image, disposition: "attachment") : "default_product.png"
  end
end
