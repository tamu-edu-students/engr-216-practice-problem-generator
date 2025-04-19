require "test_helper"

class Instructor::QuestionsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get instructor_questions_index_url
    assert_response :success
  end

  test "should get edit" do
    get instructor_questions_edit_url
    assert_response :success
  end

  test "should get update" do
    get instructor_questions_update_url
    assert_response :success
  end

  test "should get destroy" do
    get instructor_questions_destroy_url
    assert_response :success
  end
end
