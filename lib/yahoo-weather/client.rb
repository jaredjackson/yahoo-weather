# The main client object through which the Yahoo! Weather service may be accessed.
class YahooWeather::Client
  # the url with which we obtain weather information from yahoo
  @@API_URL = "http://xml.weather.yahoo.com/forecastrss"

  def initialize (api_url = @@API_URL)
    @api_url = api_url
  end

  # Returns a YahooWeather::Response object detailing the current weather
  # information for the specified location.
  #
  # +location+ can be either a US zip code or a location code.  Location
  # codes can be looked up at http://weather.yahoo.com, where it will appear
  # in the URL that results from searching on the city or zip code.  For
  # instance, searching on 'Seattle, WA' results in a URL ending in
  # 'USWA0395.html', so the location code for Seattle is 'USWA0395'.
  #
  # +units+ allows specifying whether to retrieve information in
  # +Fahrenheit+ as +f+, or +Celsius+ as +c+, and defaults to +f+.
  def lookup_location (location, units = 'f')
    # query the service to grab the xml data
    url = _request_url(location, units)
    begin
       response = Net::HTTP.get_response(URI.parse(url)).body.to_s
    rescue
      raise "failed to get weather via '#{url}': " + $!
    end

    # create the response object
    response = XmlSimple.xml_in(response)
    YahooWeather::Response.new(location, url, response)
  end

  private

    def _request_url (location, units)
      @api_url + '?p=' + URI.encode(location) + '&u=' + URI.encode(units)
    end

end
