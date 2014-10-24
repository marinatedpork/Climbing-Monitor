require_relative 'second-level-scraper'
class MountainProject
  def self.scrape_some_shit(link_file_to_scrape_from, target, destination_file_name)
    links = File.open(link_file_to_scrape_from, 'a+').read.split(/^/).each { |x| x.strip}
    links.each do |link|
      new_link = "http://www.mountainproject.com/" + link
      scraper_links = Scraper.new(new_link, target).links
      WriteSubLocations.new(scraper_links).write_links_to_file(destination_file_name)
    end
    file = File.open(destination_file_name, 'r').read.split("\n")
    File.open(destination_file_name, 'w') {}
    file.uniq.each do |line|
      File.open(destination_file_name, 'a+') { |file| file.write("#{line}\n") }
    end
  end
end
# page_data.search('table#leftNavRoutes'): gets the nav bar for routes on each wall's page

