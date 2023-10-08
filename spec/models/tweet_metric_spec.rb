# == Schema Information
#
# Table name: tweet_metrics
#
#  id         :bigint           not null, primary key
#  bookmarks  :integer          default(0)
#  likes      :integer          default(0)
#  replies    :integer          default(0)
#  reposts    :integer          default(0)
#  views      :integer          default(0)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  tweet_id   :bigint           not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_tweet_metrics_on_tweet_id                 (tweet_id)
#  index_tweet_metrics_on_tweet_id_and_created_at  (tweet_id,created_at) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (tweet_id => tweets.id)
#  fk_rails_...  (user_id => users.id)
#
require "rails_helper"

RSpec.describe TweetMetric, type: :model do
  describe "associations" do
    it "belongs to a tweet" do
      association = described_class.reflect_on_association(:tweet)
      expect(association.macro).to eq(:belongs_to)
    end

    it "belongs to a user" do
      association = described_class.reflect_on_association(:user)
      expect(association.macro).to eq(:belongs_to)
    end
  end
end
