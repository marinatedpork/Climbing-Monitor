thing = CSV.open('../db/all_routes.csv').read

sport = thing.select { |x| x[1] == 'sport'}
trad = thing.select { |x| x[1] == 'trad'}
ice = thing.select { |x| x[1] == 'ice'}
alpine = thing.select { |x| x[1] == 'alpine'}
boulder = thing.select { |x| x[1] == 'boulder'}
mixed = thing.select { |x| x[1] == 'mixed'}

sport_numbers = sport.select { |x| x[3] }
trad_numbers = trad.select { |x| x[3]}
ice_numbers = ice.select { |x| x[3]}
alpine_numbers = alpine.select { |x| x[3]}
boulder_numbers = boulder.select { |x| x[3]}
mixed_numbers = mixed.select { |x| x[3]}




