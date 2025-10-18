Property.where("situs_address LIKE ?", Property.sanitize_sql_like("4011") + "%")

Property.where("situs_address LIKE ?", Property.sanitize_sql_like(params[:search]) + "%")

@properties = Property.where("situs_address LIKE ?", Property.sanitize_sql_like("4019") + "%").page(params[:page]).per(100)
