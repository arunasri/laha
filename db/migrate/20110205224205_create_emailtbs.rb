class CreateEmailtbs < ActiveRecord::Migration
  def self.up
    create_table :emailtbs do |t|
      t.datetime :sent_at
      t.text :data

      t.timestamps
    end
  end

  def self.down
    drop_table :emailtbs
  end
end
