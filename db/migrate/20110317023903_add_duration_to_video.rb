class AddDurationToVideo < ActiveRecord::Migration
  def self.up
    add_column :videos, :feed_id,   :integer
    add_column :videos, :category,  :string
    add_column :videos, :keywords,  :text
    add_column :videos, :duration,  :integer
    add_column :videos, :rating,    :float
    add_column :videos, :view_count,:integer
    add_column :videos, :racy,      :boolean, :default => false

    remove_column :videos, :feed_owner
  end

  def self.down
    remove_column :videos, :view_count
    remove_column :videos, :category
    remove_column :videos, :keywords
    remove_column :videos, :duration
    remove_column :videos, :feed_id
    remove_column :videos, :racy
    remove_column :videos, :rating

    add_column    :videos, :feed_owner, :string
  end
end
