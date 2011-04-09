class CreateShows < ActiveRecord::Migration
  def self.up
    create_table :shows do |t|
      t.string :name
      t.string :description
      t.string :genre
      t.string :cast
      t.string :director
      t.string :wiki_url
      t.date   :started_on
      t.integer :year

      t.timestamps
    end
  end

  def self.down
    drop_table :shows
  end
end
