require "test_helper"

class StoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @story = stories(:one)
    @user = users(:one)
    sign_in @user
  end

  test "should get index" do
    get stories_url
    assert_response :success
  end

  test "should get show" do
    get story_url(@story)
    assert_response :success
  end
end
