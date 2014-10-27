require_relative 'level-99-scraper'
require 'csv'
class RouteParser
  def self.scrape_some_shit(link_file_to_scrape_from)
    links = File.open(link_file_to_scrape_from, 'a+').read.split(/^/).each { |x| x.strip}
    links.each do |link|
      new_link = "http://www.mountainproject.com" + link
      scraper = Scraper.new(new_link)
      CSV.open("../db/routes.csv", "a+") { |csv| csv << [scraper.route_name, scraper.route_type, scraper.route_rating, scraper.route_rating_as_int, scraper.height_or_nil, scraper.pitches, new_link.strip] }
    end
  end
end
