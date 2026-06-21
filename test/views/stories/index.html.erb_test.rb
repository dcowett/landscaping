require "test_helper"

class StoriesIndexViewTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    sign_in @user
  end

  test "index renders table and story rows" do
    get stories_url
    assert_response :success
    assert_select "table.table"
    assert_select "td", text: stories(:one).name
    assert_select "td", text: stories(:two).name
  end

  test "index renders tags" do
    story = stories(:one)
    tag = ActsAsTaggableOn::Tag.create!(name: "alpha")
    ActsAsTaggableOn::Tagging.create!(tag: tag, taggable: story, context: "tags")

    get stories_url
    assert_response :success
    assert_select "span.tags a", text: "alpha"
    assert_select "span.tags a[href=?]", tag_path(id: "alpha")
  end

  test "index renders multiple tags and label" do
    story = stories(:one)
    tag1 = ActsAsTaggableOn::Tag.create!(name: "alpha")
    tag2 = ActsAsTaggableOn::Tag.create!(name: "beta")
    ActsAsTaggableOn::Tagging.create!(tag: tag1, taggable: story, context: "tags")
    ActsAsTaggableOn::Tagging.create!(tag: tag2, taggable: story, context: "tags")

    get stories_url
    assert_response :success
    assert_select "span.tags a", text: "alpha"
    assert_select "span.tags a", text: "beta"
    assert_select "span.tags a[href=?]", tag_path(id: "alpha")
    assert_select "span.tags a[href=?]", tag_path(id: "beta")
    assert_select "td", /Tags:/
  end
end
