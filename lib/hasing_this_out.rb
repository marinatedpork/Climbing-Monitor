require_relative 'level-99-scraper'

s = Scraper.new('http://www.mountainproject.com/v/too-many-video-games/109335019')
puts s.return_route_name
puts s.route_type
puts s.route_rating
puts s.route_rating_as_int
puts s.pitches
puts s.height_or_nil

# d =Scraper.new('http://www.mountainproject.com/v/epinephrine/105732422')
# puts d.return_route_name
# puts d.route_type
# puts d.route_rating
# puts d.route_rating_as_int
# puts d.pitches
# puts d.height_or_nil