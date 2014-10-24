class Wall < ActiveRecord::Base
  belongs_to :area
  belongs_to :state
  has_many :routes
end
