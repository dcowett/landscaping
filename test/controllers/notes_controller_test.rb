require "test_helper"

class NotesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @note = notes(:one)
    @property = properties(:one)
    sign_in users(:one)
  end

  test "should get index" do
    get notes_url
    assert_response :success
  end

  test "should get new" do
    get new_property_note_url(@property)
    assert_response :success
  end

  test "should create note" do
    assert_difference("Note.count") do
    post property_notes_url(@property), params: { note: { code: @note.code, notes: @note.notes, property_id: @property.id } }
  end

  assert_redirected_to property_url(@property)  # was property_note_url
end

  test "should show note" do
    get property_note_url(@property, @note)
    assert_response :success
  end

  test "should get edit" do
    get edit_property_note_url(@property, @note)
    assert_response :success
  end

 test "should update note" do
    patch property_note_url(@property, @note), params: { note: { code: @note.code, notes: @note.notes } }
    assert_redirected_to property_url(@property)  # was property_note_url
  end

  test "should destroy note" do
    assert_difference("Note.count", -1) do
    delete property_note_url(@property, @note)
  end

  assert_redirected_to property_url(@property)  # was property_notes_url
end









end
