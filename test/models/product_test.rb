require "test_helper"

class ProductTest < ActiveSupport::TestCase
  ## Specifying which fixtures to load when performing Tests
  # If not specifying fixtures then all fixtures will be loaded
  fixtures :products

  ## Test for form elements not being empty
  test 'product attributes must not be empty' do 
    ## Trying empty product not to pass any validation
    product = Product.new

    ## Assert line is the test case
    assert product.invalid?
    assert product.errors[:title].any?
    assert product.errors[:description].any?
    assert product.errors[:price].any?
    assert product.errors[:image_url].any?
  end

  ## Test for positive price 
  test 'product price must be positive' do
    product = Product.new(
      title: 'My Book Title',
      description: 'yyy',
      image_url: 'zzz.jpg'
    )
    product.price = -1

    assert product.invalid?
    assert_equal ["must be greater than or equal to 0.01"], product.errors[:price]
    
    product.price = 0
    assert product.invalid?
    assert_equal ["must be greater than or equal to 0.01"], product.errors[:price]

    product.price = 1
    assert product.valid?
  end

  def new_product(image_url)
    Product.new(
      title: 'My Book Title',
      description: 'yyy',
      price: 1,
      image_url: image_url
    )
  end

  ## Test for valid and invalud image url
  test 'image url' do
    ok = %w{ fred.gif fred.jpg fred.png FRED.JPG FRED.Jpg
      http://a.b.c/x/y/z/fred.gif }
    bad = %w{ fred.doc fred.gif/more fred.gif.more }

    ## Passing parameter to assert is additional message that will be
    ## attached to error message if test fails
    ok.each do |image_url|
      assert new_product(image_url).valid?, "#{image_url} shouldn't be invalid"
    end

    bad.each do |image_url|
      assert new_product(image_url).invalid?, "#{image_url} shouldn't be valid"
    end
  end

  ## Test for unique title in table
  test 'product is not valid without unique title' do
    # Using Fixture to access data
    product = Product.new(
      title: products(:ruby).title,
      description: 'yyy',
      price: 1,
      image_url: 'fred.gif'
    )

    assert product.invalid?, 'should not be valid as title already exist'
    assert_equal ['has already been taken'], product.errors[:title]
  end

end
