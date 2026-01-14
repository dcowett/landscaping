require "test_helper"

class StoriesIndexViewTest < ActionView::TestCase
  fixtures :stories

  def test_index_renders_table_and_story_rows
    assign(:stories, Story.all)
    render template: "stories/index"

    # Expect two table rows per story (main row + description/tags row)
    assert_select "table.table" do
      assert_select "tbody tr", Story.count * 2
    end

    # Ensure story names appear in the rendered output
    assert_select "td", text: stories(:one).name
    assert_select "td", text: stories(:two).name
  end

  def test_index_renders_tags
    story = stories(:one)

    # Create a tag and associate it to the fixture story via Tagging
    tag = ActsAsTaggableOn::Tag.create!(name: "alpha")
    ActsAsTaggableOn::Tagging.create!(tag: tag, taggable: story, context: "tags")

    assign(:stories, Story.all)
    render template: "stories/index"

    # The tags are rendered via the tags/_tag partial as links inside .tags
    assert_select "span.tags a", text: "alpha"

    # And the link should point to the tag_path (tag name used as id param)
    assert_select "span.tags a[href=?]", tag_path(id: "alpha")
  end

  def test_index_renders_multiple_tags_and_label
    story = stories(:one)

    tag1 = ActsAsTaggableOn::Tag.create!(name: "alpha")
    tag2 = ActsAsTaggableOn::Tag.create!(name: "beta")

    ActsAsTaggableOn::Tagging.create!(tag: tag1, taggable: story, context: "tags")
    ActsAsTaggableOn::Tagging.create!(tag: tag2, taggable: story, context: "tags")

    assign(:stories, Story.all)
    render template: "stories/index"

    # Both tags should be rendered as links inside the .tags span
    assert_select "span.tags a", text: "alpha"
    # And the link should point to the tag_path
    assert_select "span.tags a[href=?]", tag_path(id: "alpha")
    assert_select "span.tags a", text: "beta"
    # And the link should point to the tag_path
    assert_select "span.tags a[href=?]", tag_path(id: "beta")

    # And the "Tags:" label should appear in the same cell
    assert_select "td", /Tags:/
  end
end
