class CreateTweetMetrics < ActiveRecord::Migration[7.1]
  def change
    create_table :tweet_metrics do |t|
      t.references :tweet, null: false, foreign_key: true
      t.integer :replies, default: 0
      t.integer :reposts, default: 0
      t.integer :likes, default: 0
      t.integer :bookmarks, default: 0
      t.integer :views, default: 0

      t.timestamps
    end
  end
end
