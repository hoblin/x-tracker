# frozen_string_literal: true

class AddFirstTweet < ActiveRecord::Migration[7.1]
  def up
    Tweet.create(
      author: "P_Kallioniemi",
      body: "In today's #vatniksoup, I'll introduce a South African-American(!) businessman and social media figure, Elon Musk (
        @elonmusk
        ). He's best-known for being the wealthiest man in the world, running Tesla Inc., SpaceX & Twitter, and for parroting Kremlin's propaganda narratives.

        1/24",
      url: "https://twitter.com/P_Kallioniemi/status/1674360288445964288"
    )
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
