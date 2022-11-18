module ProductsHelper
  def format_html_to_overview(html, **truncate_args)
    truncate(strip_tags(html), truncate_args)
  end
end
