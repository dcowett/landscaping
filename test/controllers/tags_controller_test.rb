require "test_helper"

class TagsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @tag = ActsAsTaggableOn::Tag.find_by(name: "ruby") || ActsAsTaggableOn::Tag.create!(name: "ruby")
    sign_in users(:one)
  end

  test "should get show" do
    get tag_url(@tag.name)
    assert_response :success
  end
end
