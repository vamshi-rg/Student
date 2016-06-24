require 'test_helper'

class StudentsControllerTest < ActionController::TestCase
  test "should get do_query" do
    get :do_query
    assert_response :success
  end

  test "should get do_queries" do
    get :do_queries
    assert_response :success
  end

end
