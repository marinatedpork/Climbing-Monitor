class Area < ActiveRecord::Migration
  def change
    create_table :areas do |t|
      t.string :name
      t.belongs_to :state
      t.timestamps
    end
  end
end
