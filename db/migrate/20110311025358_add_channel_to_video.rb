class AddChannelToVideo < ActiveRecord::Migration
  def self.up
    drop_table :channels_videos

    add_column :videos, :channel_id, :integer
  end

  def self.down
    create_table :channels_videos, :id => false do |t|
      t.references :video, :channel
    end

    remove_column :videos, :channel_id
  end
end
