class CreateFeeds < ActiveRecord::Migration
  def self.up
    create_table :feeds do |t|
      t.string  :name,      :not_null => true
      t.boolean :approved,  :default => false
      t.integer :default_channel_id

      t.timestamps
    end
  end

  def self.down
    drop_table :feeds
  end
end
