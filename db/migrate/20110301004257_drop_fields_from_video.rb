class DropFieldsFromVideo < ActiveRecord::Migration
  def self.up
    remove_column :videos, :keywords
    remove_column :videos, :thumbnail
  end

  def self.down
  end
end
