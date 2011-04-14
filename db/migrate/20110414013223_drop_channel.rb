class DropChannel < ActiveRecord::Migration
  def self.up
    drop_table    :channels
    remove_column :feeds,  :default_channel_id
    remove_column :videos, :channel_id
  end

  def self.down
  end
end
