module Tasks
  class TweetMetricsImporter
    BATCH_SIZE = 1000

    def self.import_from_sqlite(db_path = "db/database.sqlite3", batch_size = BATCH_SIZE)
      sqlite_db = SQLite3::Database.new(db_path)
      sqlite_db.results_as_hash = true
      offset = 0
      loop do
        batch = sqlite_db.execute("SELECT * FROM likes ORDER BY id ASC LIMIT #{batch_size} OFFSET #{offset}")
        break if batch.empty?
        import_batch(batch)
        offset += batch_size
      end
    end

    def self.import_batch(batch)
      transformed_rows = batch.map { |row| transform_row(row) }
      TweetMetric.upsert_all(transformed_rows, unique_by: :index_tweet_metrics_on_tweet_id_and_created_at)
    end

    def self.transform_row(row)
      {
        tweet_id: tweet.id,
        likes: row["likes"],
        created_at: row["created_at"],
        updated_at: row["updated_at"]
      }
    end

    def self.tweet
      @tweet ||= Tweet.first
    end
  end
end
