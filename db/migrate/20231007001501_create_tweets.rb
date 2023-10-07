class CreateTweets < ActiveRecord::Migration[7.1]
  def change
    create_table :tweets do |t|
      t.string :author
      t.text :body
      t.string :url, null: false

      t.timestamps
    end
  end
end
