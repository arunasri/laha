class AddShowIdToVideo < ActiveRecord::Migration
  def self.up
    add_column :videos, :show_id, :integer
  end

  def self.down
    remove_column :videos, :show_id
  end
end
