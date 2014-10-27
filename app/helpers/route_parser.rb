require_relative '../../config/database'
require_relative '../../config/environment'
require_relative 'level-99-scraper'
require_relative '../app/models/climbing_route'
class RouteParser
  def self.scrape_some_shit(link_file_to_scrape_from)
    links = File.open(link_file_to_scrape_from, 'a+').read.split(/^/).each { |x| x.strip}
    links.each do |link|
      new_link = "http://www.mountainproject.com/" + link
      scraper = Scraper.new(new_link)
      ClimbingRoute.create!(name: scraper.route_name, type: scraper.route_type, rating: scraper.route_rating, number_rating: scraper.route_rating_as_int, height: scraper.height_or_nil, pitches: scraper.pitches, url: new_link)
    end
  end
end
