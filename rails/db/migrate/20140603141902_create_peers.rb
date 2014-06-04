class CreatePeers < ActiveRecord::Migration
  def change
    create_table :peers do |t|
      t.string :api_url
      t.string :peer_url

      t.timestamps
    end
  end
end
