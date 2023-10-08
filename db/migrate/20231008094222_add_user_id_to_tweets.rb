class AddUserIdToTweets < ActiveRecord::Migration[7.1]
  def up
    add_column :tweets, :user_id, :bigint

    first_user_id = execute("SELECT id FROM users ORDER BY created_at ASC LIMIT 1").first["id"]

    raise "No users found" if first_user_id.nil?

    execute("UPDATE tweets SET user_id = #{first_user_id}")
    change_column_null :tweets, :user_id, false
    add_foreign_key :tweets, :users
  end

  def down
    remove_foreign_key :tweets, :users
    remove_column :tweets, :user_id
  end
end
