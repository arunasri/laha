class DropTypeFromVideos < ActiveRecord::Migration
  def self.up
    add_column    :videos, :kind, :string
    remove_column :videos, :type
  end

  def self.down
    add_column    :videos,  :type, :string
    remove_column :videos,  :kind
  end
end
