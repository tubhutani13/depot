require "test_helper"

class LineItemsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @line_item = line_items(:one)
  end

  test "should get index" do
    get line_items_url
    assert_response :success
  end

  test "should get new" do
    get new_line_item_url
    assert_response :success
  end

  test "should create line_item" do
    assert_difference("LineItem.count") do
      post line_items_url, params: { 
        product_id: products(:ruby).id
      }
    end

    ## performing redirect on location
    follow_redirect!

    assert_select 'h2', 'Your Cart'
    assert_select 'td', "Programming Ruby 1.9"
  end

  test "should create line_item via ajax" do
    # By-default, assert_difference checks +1
    assert_difference('LineItem.count') do
      # xhr request makes XMLHttpRequest, in which in response
      # response object expected instead of redirect 
      post line_items_url, params: { product_id: products(:ruby).id }, xhr: true
    end

    assert_response :success
    # Checking if line-item-highlight class added to newly added class item
    # @response contanins javascript recieved
    assert_match /<tr class=\\"line-item-highlight/, @response.body
  end

  test "should show line_item" do
    get line_item_url(@line_item)
    assert_response :success
  end

  test "should get edit" do
    get edit_line_item_url(@line_item)
    assert_response :success
  end

  ## Test to update line_item with a valid cart
  test "should update line_item" do
    patch line_item_url(@line_item), params: { 
      line_item: { 
        product_id: @line_item.product_id 
      } 
    }

    assert_redirected_to line_item_url(@line_item)
  end

  test "should destroy line_item" do
    assert_difference("LineItem.count", -1) do
      delete line_item_url(@line_item)
    end

    assert_redirected_to line_items_url
  end

  ## test to ensure product in a cart cannot be deleted
  test "can't delete product in cart" do
    ## verifies that the result of evaluating its first arguement
    # changes by amount passed in second argument after executing block
    assert_difference('Product.count', 0) do
      delete product_url(products(:two))
    end

    assert_redirected_to products_url
  end
end
