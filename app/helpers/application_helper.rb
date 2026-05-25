module ApplicationHelper
  def currency_or_dash(value)
    value ? number_to_currency(value) : "—"
  end
end
