class AddFeedToVideo < ActiveRecord::Migration
  def self.up
    add_column    :feeds, :processed,     :boolean, :default => false
  end

  def self.down
    remove_column :feeds, :processed
  end
end
