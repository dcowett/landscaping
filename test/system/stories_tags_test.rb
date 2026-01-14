require "application_system_test_case"

class StoriesTagsTest < ApplicationSystemTestCase
  fixtures :users

  def setup
    @user = users(:one)
  end

  test "tags render and link to tag_path from stories index" do
    # Create a story with tags
    story = Story.create!(name: "Tagged Story", link: "http://example.com", user: @user)
    story.tag_list.add("alpha", "beta")
    story.save!

    visit stories_path

    # Both tags should appear and be links to tag_path
    within "#stories" do
      assert_text "alpha"
      assert_text "beta"

      alpha_link = find_link("alpha")
      assert_equal tag_path(id: "alpha"), alpha_link[:href]

      beta_link = find_link("beta")
      assert_equal tag_path(id: "beta"), beta_link[:href]
    end
  end
end
