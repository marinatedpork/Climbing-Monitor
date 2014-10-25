class CreateRoutes < ActiveRecord::Migration
  def change
    create_table   :routes do |t|
      t.string     :name
      t.string     :type
      t.string     :rating
      t.integer    :number_rating
      t.integer    :height
      t.integer    :pitches
      t.string     :url
      t.belongs_to :wall
      t.timestamps
    end
  end
end
