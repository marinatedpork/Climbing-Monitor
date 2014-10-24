require_relative "scraper"

class WriteSubLocations
  attr_reader :links, :united_states

  def initialize(links)
    @links = links
  end

  def is_a_sublocation_link?(link)
    return true if link =~ /\/v\/(.+)?\/\d{9}/
  end

  def filter_links
    filtered_links = []
    links.each { |link| filtered_links << link if is_a_sublocation_link?(link)}
    return filtered_links
  end

  def write_links_to_file(filename)
    filter_links.each do |link|
      File.open(filename, 'a+') { |file| file.write("#{link}\n") }
    end
  end
end

