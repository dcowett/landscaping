module ApplicationHelper
  def currency_or_dash(value)
    value ? number_to_currency(value) : "—"
  end

  def sortable_header(title, column)
    direction =
      (params[:sort].to_s == column.to_s && params[:direction] == "asc") ? "desc" : "asc"

    css_class =
      if params[:sort].to_s == column.to_s
        "sort sort-#{params[:direction]}"
      else
        "sort"
      end

    link_to title,
            request.query_parameters.merge(sort: column, direction: direction),
            class: css_class
  end

  # Source - https://stackoverflow.com/a/24131080
  # Posted by sumizome, Retrieved 2026-05-26, License - CC BY-SA 3.0
  def comment
  end
end
