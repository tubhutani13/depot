require "test_helper"

class StoreControllerTest < ActionDispatch::IntegrationTest

  ## Writing Functional test that checks number of elements on store page
  test "should get index" do
    # gets the index and seerts that successful response is expected
    get store_index_url
    assert_response :success

    # selecting elements using html tags and CSS notation
    # this will look into HTML thats returned
    # These tests are based on fixtures data
    assert_select 'nav.side_nav a', minimum: 4
    assert_select 'main ul.catalog li', 3
    assert_select 'h2', 'Programming Ruby 1.9'
    assert_select '.price', /\$[,\d]+.\d\d/
  end
end
