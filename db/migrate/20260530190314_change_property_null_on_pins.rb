class ChangePropertyNullOnPins < ActiveRecord::Migration[8.1]
def change
    change_column_null :pins, :property_id, true
  end
end
