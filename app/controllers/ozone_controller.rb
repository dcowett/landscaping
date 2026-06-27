class OzoneController < ApplicationController
  require "net/http"
  require "json"

  def index
    @url = "https://www.airnowapi.org/aq/forecast/zipCode/?format=application/json&zipCode=33607&date=#{Date.today.strftime("%Y-%m-%d")}&distance=150&API_KEY=#{airnow_api_key}"
    fetch_and_parse_aqi
    set_aqi_display
  end

  def zipcode
    raw = params[:zipcode].to_s.strip
    unless raw.match?(/\A\d{5}(-\d{4})?\z/)
      flash[:error] = "Please enter a valid US zip code."
      return redirect_to ozone_index_path
    end
    @zip_query = raw
    @url = "https://www.airnowapi.org/aq/forecast/zipCode/?format=application/json&zipCode=#{@zip_query}&date=#{Date.today.strftime("%Y-%m-%d")}&distance=150&API_KEY=#{airnow_api_key}"
    fetch_and_parse_aqi
    set_aqi_display
  end

  private

  def airnow_api_key
    Rails.application.credentials.airnow_api_key
    # or ENV["AIRNOW_API_KEY"]
  end

  def fetch_and_parse_aqi
    @uri = URI(@url)
    @response = Net::HTTP.get(@uri)
    @output = JSON.parse(@response)

    if @output.empty?
      @final_output = "Error"
      @final_category = "Error"
    else
      @final_output = @output[0]["AQI"]
      @final_category = @output[0]["Category"]["Name"]
      @final_area = @output[0]["ReportingArea"]
    end
  end

  def set_aqi_display
    if @final_output == "Error"
      @api_color = "bg-silver"
    elsif @final_output <= 50
      @api_color = "bg-green"
      @api_description = "Air quality is satisfactory, and air pollution poses little or no risk."
    elsif @final_output <= 100
      @api_color = "bg-yellow"
      @api_description = "Air quality is acceptable. However, there may be a risk for some people, particularly those who are unusually sensitive to air pollution."
    elsif @final_output <= 150
      @api_color = "bg-orange"
      @api_description = "Members of sensitive groups may experience health effects. The general public is less likely to be affected."
    elsif @final_output <= 200
      @api_color = "bg-red"
      @api_description = "Some members of the general public may experience health effects; members of sensitive groups may experience more serious health effects."
    elsif @final_output <= 250
      @api_color = "bg-purple"
      @api_description = "Health alert: The risk of health effects is increased for everyone."
    elsif @final_output <= 500
      @api_color = "bg-maroon"
      @api_description = "Health warning of emergency conditions: everyone is more likely to be affected."
    else
      @api_color = "bg-silver"
    end
  end
end
