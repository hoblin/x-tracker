class AddAvatarToTweets < ActiveRecord::Migration[7.1]
  def change
    add_column :tweets, :avatar, :string
  end
end
