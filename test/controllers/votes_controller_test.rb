require "test_helper"

class VotesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @story = stories(:one)
    @user = users(:one)
    sign_in @user
  end

  test "should create vote" do
    assert_difference("Vote.count") do
      post story_votes_url(@story)
    end

    assert_redirected_to story_url(@story)
  end
end
