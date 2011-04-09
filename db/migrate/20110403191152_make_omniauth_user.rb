class MakeOmniauthUser < ActiveRecord::Migration
  def self.up
    remove_column :users, :password_hash
    remove_column :users, :password_salt
    remove_column :users, :altp
    add_column    :users, :provider, :string
    add_column    :users, :uid, :string
    add_column    :users, :admin, :boolean, :default => false
  end

  def self.down
    remove_column :users, :uid
    remove_column :users, :provider
    remove_column :users, :admin
    add_column :users, :password_hash, :string
    add_column :users, :password_salt, :string
    add_column :users, :altp, :string
  end
end
