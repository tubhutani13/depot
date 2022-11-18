require "application_system_test_case"

class OrdersTest < ApplicationSystemTestCase
  # included to test jobs
  include ActiveJob::TestHelper

  setup do
    @order = orders(:one)
  end

  test "visiting the index" do
    visit orders_url
    assert_selector "h1", text: "Orders"
  end

  test "should create order" do
    visit orders_url
    click_on "New order"

    fill_in "Address", with: @order.address
    fill_in "Email", with: @order.email
    fill_in "Name", with: @order.name
    fill_in "Pay type", with: @order.pay_type
    click_on "Create Order"

    assert_text "Order was successfully created"
    click_on "Back"
  end

  test "should update Order" do
    visit order_url(@order)
    click_on "Edit this order", match: :first

    fill_in "Address", with: @order.address
    fill_in "Email", with: @order.email
    fill_in "Name", with: @order.name
    fill_in "Pay type", with: @order.pay_type
    click_on "Update Order"

    assert_text "Order was successfully updated"
    click_on "Back"
  end

  test "should destroy Order" do
    visit order_url(@order)
    click_on "Destroy this order", match: :first

    assert_text "Order was successfully destroyed"
  end

  # This test will not work for now because of webpack issue of not rendering component first time
  test "check routing number" do
    # Deleting any lineitem or Order created by other tests
    LineItem.delete_all
    Order.delete_all

    visit store_index_url

    click_on 'Add to Cart', match: :first
    
    click_on 'Checkout'

    # To get around refreshing bug of form
    visit order_index_url

    fill_in 'order_name', with: 'Dave Thomas'
    fill_in 'order_address', with: '123 Main'
    fill_in 'order_email', with: 'dave@example.com'
    
    ## Checking if element with if #order_routing_number is not on screen before 'Check' type clicked
    assert_no_selector "#order_routing_number"

    select 'Check', from: 'Pay type'

    ## Checking if element with if #order_routing_number is on screen
    assert_selector "#order_routing_number"

    fill_in "Routing #", with: "123456"
    fill_in "Account #", with: "987654"

    # Making sure the jobs get executed after perfoming actions inside block
    perform_enqueued_jobs do
      # Rails will execute all the jobs queue because of this block code
      click_button "Place Order"
    end

    ## Checking if Order was created
    orders = Order.all
    assert_equal 1, orders.size

    order = orders.first

    assert_equal "Dave Thomas", order.name
    assert_equal "123 Main Street", order.address
    assert_equal "dave@example.com", order.email
    assert_equal "Check", order.pay_type

    assert_equal 1, order.line_items.size

    ## Testing if mails was sent
    # In testing env, mails are not sent but stored in ActionMailer::Base.deliveries()
    mail = ActionMailer::Base.deliveries.last
    assert_equal ["dave@example.com"], mail.to
    assert_equal 'Sam Ruby <depot@example.com>', mail[:from].value
    assert_equal 'Pragmatic Store Order Confirmation', mail.subject
  end


end
