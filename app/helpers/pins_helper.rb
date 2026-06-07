module PinsHelper
  def filter_button(label, filter_value, current)
    active = (filter_value.nil? && current.nil?) || current == filter_value
    classes = "btn #{active ? 'btn-primary' : 'btn-outline-secondary'}"

    link_to label, pins_path(filter: filter_value), class: classes
  end
end
