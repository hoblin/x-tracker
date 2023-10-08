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
#
# Indexes
#
#  index_tweet_metrics_on_tweet_id                 (tweet_id)
#  index_tweet_metrics_on_tweet_id_and_created_at  (tweet_id,created_at) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (tweet_id => tweets.id)
#
FactoryBot.define do
  factory :tweet_metric do
    tweet_id { nil }
    replies { 1 }
    reposts { 1 }
    likes { 1 }
    bookmarks { 1 }
    views { 1 }
  end
end
