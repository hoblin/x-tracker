class AddUuidToTweets < ActiveRecord::Migration[7.1]
  def change
    add_column :tweets, :uuid, :uuid, default: "gen_random_uuid()", null: false
    add_index :tweets, :uuid, unique: true
  end
end
