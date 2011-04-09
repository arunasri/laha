class AddLanguageToShow < ActiveRecord::Migration
  def self.up
    add_column :shows, :language, :string
  end

  def self.down
    remove_column :shows, :language
  end
end
