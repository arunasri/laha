class CreateVideos < ActiveRecord::Migration
  def self.up
    create_table :videos do |t|
      t.string    :name
      t.text      :description
      t.string    :thumbnail
      t.string    :feed_owner
      t.string    :keywords
      t.string    :youtube_id
      t.datetime  :published_at
      t.boolean   :approved, :default => false

      t.timestamps
    end
  end

  def self.down
    drop_table :videos
  end
end
