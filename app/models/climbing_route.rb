require_relative '../../config/environment'
require_relative '../../config/database'
class ClimbingRoute < ActiveRecord::Base
  belongs_to :state
  belongs_to :area
  belongs_to :wall
end
