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

  def return_rating_as_int(return_rating)
    rating = return_rating
    if rating =~ /\./
      if rating.length == 3 #5.8
        return rating[2].to_i
      elsif (rating.length == 4) && (rating[4] =~ /\D/) #5.9+
        return rating[3].to_i
      else (rating.length >= 4) && (rating[4] =~ /\d/) #5.10, 5.11b, 5,13+
        return rating[2..3].to_i
      end
    elsif rating =~ /[(ai)(wi)]/i
      if rating.length <= 4
        return rating[2].to_i
      else
        return rating[2].to_f + (".5").to_f
      end
    else
      if (rating.length == 3) && !(rating[2] =~ /\D/)
        return rating[1..2].to_i
      else
        return rating[1].to_i
      end
    end
  end


  def return_route_name
    page_data.search('h1.dkorange').text
  end

  def return_route_stats
    route_types = [/boulder/i, /sport/i, /trad/i, /ice/i, /mixed/i]
    # Grabs table into string from TYPE to SUBMITTED
    info_string = page_data.search('div.rspCol span table td').text
    slice_index = info_string =~ /consensus/i
    reverse_stat_string = info_string.slice(0..slice_index).reverse
    if reverse_stat_string =~ /[',]/
      substring_string_slice_index = (reverse_stat_string =~ /[',]/) + 1
      stat_array = reverse_stat_string.slice(substring_string_slice_index..-1).reverse.split(/,/)
      stat_array[-1] = stat_array[-1].delete "'"
      stat_array[0] = stat_array[0].slice(6..-1)
      return stat_array.map(&:strip)
    else
      return reverse_stat_string.reverse.slice(6..-1).chop
    end
  end
end

p Scraper.new('http://mountainproject.com/v/west-couloir/107012377').return_route_stats
puts ""
p Scraper.new('http://mountainproject.com/v/paper-or-plastic/106960952').return_route_stats
puts ""
p Scraper.new('http://mountainproject.com/v/the-hourglass-couloir/105814388').return_route_stats
puts ""
p Scraper.new('http://mountainproject.com/v/lakota-son/108278734').return_route_stats
puts ""
# page_data.search('div.rspCol span table td').text.split("\n").slice(0..(page_data.search('div.rspCol span table td').text.split("\n")[0] =~ /,/))
p Scraper.new('http://mountainproject.com/v/right-gully/106059718').return_route_stats
puts ""

p Scraper.new('http://mountainproject.com/v/choo-choo-charley/107795859').return_route_stats
puts ""
p Scraper.new('http://mountainproject.com/v/balcony-center/105870943').return_route_stats
puts ""
p Scraper.new('http://mountainproject.com/v/deck-dyno/108943771').return_route_stats
puts ""
p Scraper.new('http://mountainproject.com/v/widow-maker/105995171').return_route_stats
puts ""
