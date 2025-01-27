require "test_helper"

class InstructorHomeControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get instructor_home_index_url
    assert_response :success
  end
end
