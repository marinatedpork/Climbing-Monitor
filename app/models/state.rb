class State < ActiveRecord::Base
  has_many :areas
  has_many :walls
  has_many :routes
end
