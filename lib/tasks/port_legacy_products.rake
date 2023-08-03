namespace :product do
  desc 'Assigns first category to all products without Category'
  task :port_legacy_products => [ :environment ] do 
    category = Category.first
    if category
      updated_products = Product.where(category: nil).update!(category: category)
      puts "#{updated_products.size} number of products updated with category."
    end
  end
end
