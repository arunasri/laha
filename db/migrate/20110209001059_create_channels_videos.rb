class CreateChannelsVideos < ActiveRecord::Migration
  def self.up
    create_table :channels_videos, :id => false do |t|
      t.references :video, :channel
    end
  end

  def self.down
    drop_table :channels_videos
  end
end
