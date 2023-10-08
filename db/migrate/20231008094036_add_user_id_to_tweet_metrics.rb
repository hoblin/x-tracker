class AddUserIdToTweetMetrics < ActiveRecord::Migration[7.1]
  def up
    add_column :tweet_metrics, :user_id, :bigint

    first_user_id = execute("SELECT id FROM users ORDER BY created_at ASC LIMIT 1").first["id"]

    raise "No users found" if first_user_id.nil?

    execute("UPDATE tweet_metrics SET user_id = #{first_user_id}")
    change_column_null :tweet_metrics, :user_id, false
    add_foreign_key :tweet_metrics, :users
  end

  def down
    remove_foreign_key :tweet_metrics, :users
    remove_column :tweet_metrics, :user_id
  end
end
