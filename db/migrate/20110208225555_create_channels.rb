class CreateChannels < ActiveRecord::Migration
  def self.up
    create_table :channels do |t|
      t.string :name,     :not_null => true
      t.string :language, :not_null => true

      t.timestamps
    end
  end

  def self.down
    drop_table :channels
  end
end
