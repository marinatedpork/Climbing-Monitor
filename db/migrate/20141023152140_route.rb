class Route < ActiveRecord::Migration
  def change
    create_table   :routes do |t|
      t.string     :name
      t.string     :type
      t.integer    :number_rating
      t.string     :rating
      t.integer    :height
      t.integer    :pitches
      t.string     :fa
      t.text       :route_description
      t.text       :location_description
      t.text       :protection
      t.belongs_to :wall
      t.timestamps
    end
  end
end
