class AddAssociationNameToChannel < ActiveRecord::Migration
  def self.up
    add_column :channels, :show_association_name, :string
  end

  def self.down
    remove_column :channels, :show_association_name
  end
end
