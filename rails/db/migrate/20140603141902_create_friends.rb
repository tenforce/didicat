class CreateFriends < ActiveRecord::Migration
  def change
    create_table :friends do |t|
      t.string :url

      t.timestamps
    end
  end
end
