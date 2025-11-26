class PropertiesController < ApplicationController
  before_action :set_property, only: %i[ show edit update destroy ]

  # GET /properties or /properties.json
  def index
    if !params[:search].nil?
      @properties = Property.where("situs_address LIKE ?", "%" + params[:search].upcase + "%").page(params[:page]).per(100)
    else
      @properties = Property.all.order("last_sale_date DESC").page(params[:page]).per(100)
    end

    respond_to do |format|
      format.html
      format.csv { send_data Property.to_csv, filename: "properties-#{DateTime.now.strftime("%d%m%Y%H%M")}.csv" }
    end
  end

  # GET /properties/1 or /properties/1.json
  def show
    @property = Property.find(params[:id])
    @note = @property.notes.order("created_at DESC")
  end

  # GET /properties/new
  def new
    @property = Property.new
  end

  # GET /properties/1/edit
  def edit
  end

  # POST /properties or /properties.json
  def create
    @property = Property.new(property_params)

    respond_to do |format|
      if @property.save
        format.html { redirect_to @property, notice: "Property was successfully created." }
        format.json { render :show, status: :created, location: @property }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @property.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /properties/1 or /properties/1.json
  def update
    respond_to do |format|
      if @property.update(property_params)
        format.html { redirect_to @property, notice: "Property was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @property }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @property.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /properties/1 or /properties/1.json
  def destroy
    @property.destroy!

    respond_to do |format|
      format.html { redirect_to properties_path, notice: "Property was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  #  Import CSV file of properties
  def import
    import_file = params[:file]
    if import_file.present? && import_file.content_type == "text/csv"
      Property.import(import_file)
      redirect_to properties_path, notice: "Properties added succuessfully"
    else
      redirect_to new_property_path, notice: "CSV file required"
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_property
      @property = Property.find(params[:id])
      rescue ActiveRecord::RecordNotFound => e
      #  redirect_to '/404'
      flash[:error] = e
      redirect_to properties_path
    end

    # Only allow a list of trusted parameters through.
    def property_params
      params.expect(property: [ :parid, :situs_address, :situs_postal_city, :situs_postal_zip, :land_use_code, :land_use_desc, :homestead_indicator, :tax_district, :last_sale_date, :last_sale_vori, :last_sale_qualified, :last_sale_price, :land_acreage, :bldg1_year_built, :bldgs_sqft_living, :bldgs_sqft_unroof, :swimming_pool, :community_dev_dist, :cra_name, :neighborhood_code, :neighborhood_name, :subdivision_code, :subdivision_name, :just_value, :county_assessed_value, :county_exempt_value, :county_taxable_value, :owner_name_line1, :owner_name_line2, :mailing_address_line1, :mailing_address_line2, :mailing_city, :mailing_state, :mailing_postal_code, :mailing_country, :search ])
    end
end
