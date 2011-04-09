class AddQuarlityToVideos < ActiveRecord::Migration
  def self.up
    add_column :videos, :quality,   :string
    add_column :videos, :language,  :string
  end

  def self.down
    remove_column :videos, :quality
    remove_column :videos, :language
  end
end
