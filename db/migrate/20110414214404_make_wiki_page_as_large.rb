class MakeWikiPageAsLarge < ActiveRecord::Migration
  def self.up
    change_column :wiki_pages, :data, :longtext
    add_column :shows, :url,  :string
    add_column :shows, :data, :longtext
    add_column :shows, :image, :binary
    add_column :shows, :music_director, :string

    add_column :videos, :singers, :string
    add_column :videos, :writer, :string
    add_column :videos, :cast, :string
  end

  def self.down
    remove_column :shows, :music_director
    remove_column :shows, :data
    remove_column :shows, :image
    remove_column :shows, :url
    remove_column :videos, :singers
    remove_column :videos, :writer
    remove_column :videos, :cast
  end
end
