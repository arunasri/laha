class CreateCrons < ActiveRecord::Migration
  def self.up
    create_table :crons do |t|
      t.string :name

      t.timestamps
    end
  end

  def self.down
    drop_table :crons
  end
end
