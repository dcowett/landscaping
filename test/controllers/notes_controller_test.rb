require "test_helper"

class NotesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @note = notes(:one)
    @property = properties(:one)
  end

  test "should get index" do
    get notes_url
    assert_response :success
  end

  test "should get new" do
    get new_property_note_url
    assert_response :success
  end

  test "should create note" do
    assert_difference("Note.count") do
      post property_notes_url, params: { note: { code: @note.code, notes: @note.notes, property_id: @note.property_id } }
    end

    assert_redirected_to property_note_url(Note.last)
  end

  test "should show note" do
    get property_note_url([@property.property_id, @note])
    assert_response :success
  end

  test "should get edit" do
    get edit_property_note_url([@property.property_id, @note])
    assert_response :success
  end

  test "should update note" do
    patch property_note_url([@property.property_id, @note]), params: { note: { code: @note.code, notes: @note.notes } }
    assert_redirected_to property_note_url(@note)
  end

  test "should destroy note" do
    assert_difference("Note.count", -1) do
      delete property_note_url(@note)
    end

    assert_redirected_to property_notes_url
  end
end
