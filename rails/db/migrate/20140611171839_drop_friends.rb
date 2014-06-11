class DropFriends < ActiveRecord::Migration
  def up
    drop_table :friends
  end

  def down
    create_table :friends do |t|
      t.string :url

      t.timestamps
    end
  end
end
