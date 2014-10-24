require 'nokogiri'
require 'net/http'

class Scraper
  attr_reader :page_data
  attr_accessor :url

  def initialize(url)
    @url = url
    @page_data = fetch!
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

  def return_rating
    if page_data.search('span.rateYDS').xpath('text()').empty?
      ratings = page_data.search('span.rateHueco').xpath('text()').to_a.delete_if { |node| node.blank? }
      return ratings[0].text
    end
    page_data.search('span.rateYDS').xpath('text()').empty?
    ratings = page_data.search('span.rateYDS').xpath('text()').to_a.delete_if { |node| node.blank? }
    return ratings[0].text
  end

  def return_route_name
    page_data.search('h1.dkorange').text
  end

  def return_route_type
    page_data.search('div.rspCol table').text
  end

end
