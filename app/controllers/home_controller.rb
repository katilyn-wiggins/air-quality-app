class HomeController < ApplicationController
  def index
    # goes onto http websites and collects data
    require 'net/http'
    # parses information we get from websites to be more readable
    # if not installed can be found via rubygems
    require 'json'

    @base_url = 'https://www.airnowapi.org/aq/observation/zipCode/current/?format=application/json'

    @zipcode = params[:zipcode]

    @url = "#{@base_url}&zipCode=#{@zipcode}&distance=0&API_KEY=#{ENV['airnow_api_key']}"
    @uri = URI(@url)
    @response = Net::HTTP.get(@uri)
    @output = JSON.parse(@response)

    # error handling - check for empty return result
    if @output.empty?
      @final_output = 'Error'
    elsif !@output
      @final_output = 'Error'
    else
      @final_output = @output[0]['AQI']
    end

    # color of jumbotron based on AQI reading
    if @final_output == 'Error'
      @api_color = "error"
    elsif @final_output <= 50
      @api_color = "green"
    elsif @final_output >= 51 && @final_output <= 100
      @api_color = "yellow"
    elsif @final_output >= 101 && @final_output <= 150
      @api_color = "orange"
    elsif @final_output >= 151 && @final_output <= 200
      @api_color = "red"
    elsif @final_output >= 201 && @final_output <= 250
      @api_color = "purple"
    elsif @final_output >= 251 && @final_output <= 300
      @api_color = "maroon"
    end

    #description based on AQI reading
    if @final_output == 'Error'
      @description = "Error. Please try submitting your zipcode again."
    elsif @final_output <= 50
      @description = "Your neighborhood air quality is Good. The AQI value for your community is between
      0 and 50. Air quality is satisfactory and poses little or no
      health risk."
    elsif @final_output >= 51 && @final_output <= 100
      @description = "Your neighborhood air quality is" + " Moderate. The AQI is between 51 and 100. Air quality
      is acceptable; however, pollution in this range may pose a
      moderate health concern for a very small number of individuals. People who are unusually sensitive to ozone or
      particle pollution may experience respiratory symptoms."
    elsif @final_output >= 101 && @final_output <= 150
      @description = "Your neighborhood air quality is" + "Unhealthy for Sensitive Groups. When AQI values
      are between 101 and 150, members of sensitive groups
      may experience health effects, but the general public is
      unlikely to be affected."
    elsif @final_output >= 151 && @final_output <= 200
      @description = "Your neighborhood air quality is" + "Unhealthy. Everyone may begin to experience health effects
    when AQI values are between 151 and 200. Members of
    sensitive groups may experience more serious health effects."
    elsif @final_output >= 201 && @final_output <= 250
      @description = "Your neighborhood air quality is" + "Very Unhealthy. AQI values between 201 and 300
      trigger a health alert, meaning everyone may experience
      more serious health effects."
    elsif @final_output >= 251 && @final_output <= 300
      @description = "Your neighborhood air quality is" + "Hazardous. AQI values over 300 trigger health warnings
      of emergency conditions. The entire population is even
      more likely to be affected by serious health effects."
    end
  end
end
