# Describes the weather conditions for a particular requested location.
class YahooWeather::Response
  # a YahooWeather::Astronomy object detailing the sunrise and sunset
  # information for the requested location.
  attr_reader :astronomy

  # a YahooWeather::Location object detailing the precise geographical names
  # to which the requested location was mapped.
  attr_reader :location

  # a YahooWeather::Units object detailing the units corresponding to the
  # information detailed in the response.
  attr_reader :units

  # a YahooWeather::Wind object detailing the wind information at the
  # requested location.
  attr_reader :wind

  # a YahooWeather::Atmosphere object detailing the atmosphere information
  # of the requested location.
  attr_reader :atmosphere

  # a YahooWeather::Condition object detailing the current conditions of the
  # requested location.
  attr_reader :condition

  # a list of YahooWeather::Forecast objects detailing the high-level
  # forecasted weather conditions for upcoming days.
  attr_reader :forecasts

  # the raw HTML generated by the Yahoo! Weather service summarizing current
  # weather conditions for the requested location.
  attr_reader :description

  # a link to the Yahoo! Weather image icon representing the current weather
  # conditions visually.
  attr_reader :image_url

  # the latitude of the location for which weather is detailed.
  attr_reader :latitude

  # the longitude of the location for which weather is detailed.
  attr_reader :longitude

  # a link to the Yahoo! Weather page with full detailed information on the
  # requested location's current weather conditions.
  attr_reader :page_url

  # the location string initially requested of the service.
  attr_reader :request_location

  # the url with which the Yahoo! Weather service was accessed to build the response.
  attr_reader :request_url

  # the prose descriptive title of the weather information.
  attr_reader :title

  # regular expression used to pull the weather image icon from full
  # description text.
  @@REGEXP_IMAGE = Regexp.new(/img src="([^"]+)"/)

  def initialize (request_location, request_url, payload)
    @request_location = request_location
    @request_url = request_url

    root = payload['channel'].first
    @astronomy = YahooWeather::Astronomy.new root['astronomy'].first
    @location = YahooWeather::Location.new root['location'].first
    @units = YahooWeather::Units.new root['units'].first
    @wind = YahooWeather::Wind.new root['wind'].first
    @atmosphere = YahooWeather::Atmosphere.new root['atmosphere'].first

    item = root['item'].first
    @condition = YahooWeather::Condition.new item['condition'].first
    @forecasts = []
    item['forecast'].each { |forecast| @forecasts << YahooWeather::Forecast.new(forecast) }
    @latitude = item['lat'].first.to_f
    @longitude = item['long'].first.to_f
    @page_url = item['link'].first
    @title = item['title'].first
    @description = item['description'].first

    match_data = @@REGEXP_IMAGE.match(description)
    @image_url = (match_data) ? match_data[1] : nil
  end
end
