require 'nokogiri'
require 'net/http'

class Scraper
  attr_reader :page_data
  attr_accessor :url

  def initialize(url, target)
    raise ArgumentError unless target.is_a? String
    @url = url
    @page_data = fetch!.search("#{target}")
  end

  def fetch!
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Get.new(uri.request_uri)
    response = http.request(request)
    if response.code == "301"
      @url = response.header['location']
      fetch!
    else
      Nokogiri::HTML(response.body)
    end
  end

  def links
    res = []
    @page_data.search('a').map {|link| res << link['href'] }
    return res.uniq.compact
  end
end
