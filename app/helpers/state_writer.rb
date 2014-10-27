class WriteStates
  attr_reader :links, :united_states

  def initialize(links)
    @links = links
  end

  def is_a_state_link?(link)
    united_states = ["alabama","alaska","arizona","arkansas","california","colorado","connecticut","delaware","florida","georgia","hawaii","idaho","illinois", "indiana","iowa","kansas","kentucky","louisiana","maine","maryland","massachusetts","michigan","minnesota","mississippi","missouri","montana", "nebraska","nevada","new-hampshire","new-jersey","new-mexico","new-york","north-carolina","north-dakota","ohio","oklahoma","oregon","pennsylvania","rhode-island","south-carolina","south-dakota","tennessee","texas","utah","vermont","virginia","washington","west-virginia","wisconsin","wyoming"]
    return united_states.any? { |state| link.include?(state) }
  end

  def filter_state_links(links)
    filtered_links = []
    links.each { |link| filtered_links << link if is_a_state_link?(link)}
    return filtered_links
  end

  def write_links_to_file
    filter_state_links(links).each do |link|
      File.open('state_links.txt', 'a+') { |file| file.write("#{link}\n") }
    end
  end
end
