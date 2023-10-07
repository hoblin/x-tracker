class AddUniqueIndexToTweetMetrics < ActiveRecord::Migration[7.1]
  def change
    add_index :tweet_metrics, [:tweet_id, :created_at], unique: true, name: "index_tweet_metrics_on_tweet_id_and_created_at"
  end
end
