class Route < ActiveRecord::Base
  belongs_to :state
  belongs_to :area
  belongs_to :wall
end
