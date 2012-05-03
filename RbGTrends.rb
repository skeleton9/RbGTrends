require 'rubygems'
require 'uri'
require 'csv'
require 'httpclient'

class RbGTrends
  def initialize(username, password)
    @login_params = {
      "continue" => 'http://www.google.com/trends',
      "PersistentCookie" => "yes",
      "Email" => username,
      "Passwd" => password,
    }
    @headers = {"Referrer"=> "https://www.google.com/accounts/ServiceLoginBoxAuth",
      "Content-type"=> "application/x-www-form-urlencoded",
      'User-Agent'=> 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/535.21 (KHTML, like Gecko) Chrome/19.0.1042.0 Safari/535.21',
      "Accept"=> "text/plain"}
    @url_ServiceLoginBoxAuth = 'https://accounts.google.com/ServiceLoginBoxAuth'
    @url_Export = 'http://www.google.com/trends/viz'
    @url_CookieCheck = 'https://www.google.com/accounts/CheckCookie?chtml=LoginDoneHtml'
    _connect()
  end

  def _connect
    @client = HTTPClient.new()

    uri = URI.parse(@url_ServiceLoginBoxAuth)
    res =  @client.get(uri,@headers)

    m = res.body.match(/<input type="hidden" name="GALX" value="([a-zA-Z0-9_-]+)">/i)
    if !m
      puts "No GALX found"
    return
    end

    @login_params['GALX'] = m.captures[0]

    @client.post(uri, @login_params)
    @client.get(URI.parse(@url_CookieCheck))
  end
  
  # section is part of the csv, '' for whole csv, 'main' for the main data part, there may be others like City/Region/Language
  # q is the query word
  # date is the date range
  # geo is the region
  # these parameters you can find on google trends for details
  def csv(section = 'main', q='google',date='ytd',geo='')
    trend_params = {"graph"=>"all_csv", "sa" => "N"}
    trend_params["q"] = q
    trend_params["date"] = date
    if !geo || geo != ''
      trend_params["geo"] = geo
    end

    data = @client.get_content(URI.parse(@url_Export), trend_params)
    # empty to return all data
    if section == ''
      return CSV.parse(data)
    end
    # split data into sections
    segments = data.split("\n\n\n")
    if section == 'main'
      section = ['Week', 'Year', 'Day','Month']
    else
      section = [section]
    end

    for x in segments do
      if section.include? x.split(',')[0].strip
        maindata = CSV.parse(x)
        return maindata
      end
    end
  end
end
