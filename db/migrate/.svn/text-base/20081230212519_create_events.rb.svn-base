class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.integer :user_id
      t.string :title
      t.text :description
      t.datetime :event_date
      t.boolean :public
    end
  end

  def self.down
    drop_table :events
  end
end
