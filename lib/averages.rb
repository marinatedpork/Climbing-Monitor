require 'csv'
thing = CSV.open('../db/all_routes.csv').read

sport = thing.select { |x| x[1] == 'sport'}
trad = thing.select { |x| x[1] == 'trad'}
ice = thing.select { |x| x[1] == 'ice'}
alpine = thing.select { |x| x[1] == 'alpine'}
boulder = thing.select { |x| x[1] == 'boulder'}
mixed = thing.select { |x| x[1] == 'mixed'}

sport_numbers = []
trad_numbers = []
ice_numbers = []
alpine_numbers = []
boulder_numbers = []
mixed_numbers = []

sport.each { |x| sport_numbers << x[3] }
trad.each { |x| trad_numbers << x[3] }
ice.each { |x| ice_numbers << x[3] }
alpine.each { |x| alpine_numbers << x[3] }
boulder.each { |x| boulder_numbers << x[3] }
mixed.each { |x| mixed_numbers << x[3] }

puts sport_numbers.map(&:to_i).inject(:+) / sport_numbers.length
puts trad_numbers.map(&:to_i).inject(:+) / trad_numbers.length
puts ice_numbers.map(&:to_i).inject(:+) / ice_numbers.length
puts alpine_numbers.map(&:to_i).inject(:+) / alpine_numbers.length
puts mixed_numbers.map(&:to_i).inject(:+) / mixed_numbers.length
puts boulder_numbers.map(&:to_i).inject(:+) / boulder_numbers.length
