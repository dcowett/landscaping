class OzoneController < ApplicationController
def index
    require 'net/http'
    require 'json'

    @url = 'https://www.airnowapi.org/aq/forecast/zipCode/?format=application/json&zipCode=33607&date=2025-11-16&distance=150&API_KEY=F9296E6E-BD3D-489F-BA45-D65EBACB05B2'
    @uri = URI(@url)
    @response = Net::HTTP.get(@uri)
    @output = JSON.parse(@response)
    if @output.empty?
      @final_output = "Error"
      @final_category = "Error"
    elsif !@output
      @final_output = "Error"
      @final_category = "Error"
    else
      @final_output = @output[0]['AQI']
      @final_category = @output[0]['Category']['Name']
      @final_area = @output[0]['ReportingArea']
    end

    if @final_output == "Error"
      @api_color = "bg-silver"
    elsif @final_output <= 50
      @api_color = "bg-green"
      @api_description="Air quality is satisfactory, and air pollution poses little or no risk."
    elsif @final_output >= 51 && @final_output <= 100
      @api_color = "bg-yellow"
      @api_description="Air quality is acceptable. However, there may be a risk for some people, particularly those who are unusually sensitive to air pollution."
    elsif @final_output >= 101 && @final_output <= 150
      @api_color = "bg-orange"
      @api_description="	Members of sensitive groups may experience health effects. The general public is less likely to be affected."
    elsif @final_output >= 151 && @final_output <= 200
      @api_color = "bg-red"
      @api_description="	Some members of the general public may experience health effects; members of sensitive groups may experience more serious health effects."
    elsif @final_output >= 201 && @final_output <= 250
      @api_color = "bg-purple"
      @api_description="Health alert: The risk of health effects is increased for everyone."
    elsif @final_output >= 251 && @final_output <= 500
      @api_color = "bg-maroon"
      @api_description="Health warning of emergency conditions: everyone is more likely to be affected."
    else
      @api_color = "bg-silver"
    end
  end

  def zipcode
    @zip_query = params[:zipcode]
    if params[:zipcode] == ""
      @zip_query = "Hey, you did not enter anything"
    elsif params[:zipcode]
      # do something

    require 'net/http'
    require 'json'

    @url = 'https://www.airnowapi.org/aq/forecast/zipCode/?format=application/json&zipCode=' + @zip_query.to_s + '&date=2025-09-19&distance=150&API_KEY=F9296E6E-BD3D-489F-BA45-D65EBACB05B2'
    @uri = URI(@url)
    @response = Net::HTTP.get(@uri)
    @output = JSON.parse(@response)
    if @output.empty?
      @final_output = "Error"
      @final_category = "Error"
    elsif !@output
      @final_output = "Error"
      @final_category = "Error"
    else
      @final_output = @output[0]['AQI']
      @final_category = @output[0]['Category']['Name']
      @final_area = @output[0]['ReportingArea']
    end

    if @final_output == "Error"
      @api_color = "bg-silver"
    elsif @final_output <= 50
      @api_color = "bg-green"
      @api_description="Air quality is satisfactory, and air pollution poses little or no risk."
    elsif @final_output >= 51 && @final_output <= 100
      @api_color = "bg-yellow"
      @api_description="Air quality is acceptable. However, there may be a risk for some people, particularly those who are unusually sensitive to air pollution."
    elsif @final_output >= 101 && @final_output <= 150
      @api_color = "bg-orange"
      @api_description="	Members of sensitive groups may experience health effects. The general public is less likely to be affected."
    elsif @final_output >= 151 && @final_output <= 200
      @api_color = "bg-red"
      @api_description="	Some members of the general public may experience health effects; members of sensitive groups may experience more serious health effects."
    elsif @final_output >= 201 && @final_output <= 250
      @api_color = "bg-purple"
      @api_description="Health alert: The risk of health effects is increased for everyone."
    elsif @final_output >= 251 && @final_output <= 500
      @api_color = "bg-maroon"
      @api_description="Health warning of emergency conditions: everyone is more likely to be affected."
    else
      @api_color = "bg-silver"
    end
    end


  end

end
