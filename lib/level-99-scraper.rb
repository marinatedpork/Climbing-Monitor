require 'nokogiri'
require 'net/http'

class Scraper
  attr_reader :page_data
  attr_accessor :url, :data_array

  def initialize(url)
    @url = url
    @page_data = fetch!
    p @data_array = route_stats
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

  def route_rating
    has_no_YDS_class = page_data.search('span.rateYDS').xpath('text()').empty?
    has_no_Hueco_class = page_data.search('span.rateHueco').xpath('text()').empty?
    if [has_no_Hueco_class, has_no_YDS_class].all?
      return nil_or_encoded(page_data.search('div.rspCol span h3').text.split(' ')[0])
    elsif has_no_Hueco_class
      ratings = page_data.search('span.rateYDS').xpath('text()').to_a.delete_if { |node| node.blank? }
      rating_string = ratings[0].text.to_s
      return nil_or_encoded(rating_string[1..-1])
    else
      ratings = page_data.search('span.rateHueco').xpath('text()').to_a.delete_if { |node| node.blank? }
      rating_string = ratings[0].text.to_s
      return nil_or_encoded(rating_string[1..-1])
    end
  end

  def route_rating_as_int
    p rating = route_rating
    if rating.nil?
      return nil
    else
      if rating =~ /\./ # YDS
        if rating.length == 3 # 5.8
          return rating[2].to_i
        elsif (rating.length == 4) && (rating[4] =~ /\D/) # 5.9+
          return rating[3].to_i
        else (rating.length >= 4) && (rating[4] =~ /\d/) # 5.10, 5.11b, 5,13+
          return rating[2..3].to_i
        end
      elsif rating =~ /[(ai)(wi)]/i # Alpine or Water Ice
        if rating.length <= 4
          return rating[2].to_i # AI3+, WI5+
        else
          return rating[2].to_f + (".5").to_f # AI4-5, WI4-5
        end
      elsif rating =~ /v/i # Boulder route, Hueco scale
        if (rating.length == 3) && !(rating[2] =~ /\D/)
          return rating[1..2].to_i # V14
        elsif rating.length == 4
          return rating[1].to_f + (".5").to_f # V1-2
        elsif rating.length > 4
          return rating[1..2].to_f + (".5").to_f # V10-11
        else
          return rating[1].to_i # V4, V4+
        end
      else # Mixed route
        if rating.length == 2 # M2
          return rating[1].to_i
        else
          return rating[1].to_f + (".5").to_f
        end
      end
    end
  end

  def route_type
    stats = data_array.map(&:downcase)
    if stats.include?("boulder")
      return "boulder"
    elsif stats.include?("alpine")
      return "alpine"
    elsif route_rating =~ /m/i
      return "mixed"
    elsif stats.include?("sport")
      return "sport"
    elsif stats.include?("trad")
      return "trad"
    elsif stats.include?("tr")
      return "trad"
    else
      return "ice"
    end
  end

  def pitches
    data = data_array
    data.drop_while { |item| !(item =~ /pitch/) }.compact[0]
  end

  def height_or_nil
    heigh_or_nil = data_array.drop_while { |item| !is_int(item) }
    if heigh_or_nil.compact[0]
      return heigh_or_nil.compact[0].to_i
    else
      return nil
    end
  end

  def is_int(item)
    item.split('').all? { |thing| thing =~ /\d/ }
  end

  def route_name
    name = page_data.search('h1.dkorange').text[0..-2]
    return nil_or_encoded(name)
  end

  def route_stats
    # Grabs table into string from TYPE to SUBMITTED
    p info_string = page_data.search('div.rspCol span table td').text.encode!('UTF-8', 'binary', invalid: :replace, undef: :replace, replace: '')
    # Figures out where we need to slice it so that we can start dealing with a smaller string that has what we want
    p slice_index = info_string =~ /consensus/i
      if slice_index.nil?
        slice_index = info_string =~ /fa/i
        if slice_index.nil?
          slice_index = info_string =~ /page views/i
        end
      end
    p reverse_stat_string = info_string.slice(0..slice_index).reverse
    if reverse_stat_string =~ /[',]/ # <---- such a hot RegExp, I call that one the Yin Yang
      p substring_string_slice_index = (reverse_stat_string =~ /[',]/) + 1
      # Splits up string and cleans it
      p stat_array = reverse_stat_string.slice(substring_string_slice_index..-1).reverse.split(/,/)
      stat_array[-1] = stat_array[-1].delete "'"
      stat_array[0] = stat_array[0].slice(5..-1)
      return stat_array.map(&:strip)
    else
      return [reverse_stat_string.reverse.slice(5..-1).chop]
    end
  end

  private
    def nil_or_encoded(string)
      if string.nil?
        return nil
      else
        return string.encode!('UTF-8', 'binary', invalid: :replace, undef: :replace, replace: '')
      end
    end
end
