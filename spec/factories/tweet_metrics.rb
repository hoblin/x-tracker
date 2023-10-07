# == Schema Information
#
# Table name: tweet_metrics
#
#  id         :bigint           not null, primary key
#  tweet_id   :bigint           not null
#  replies    :integer          default(0)
#  reposts    :integer          default(0)
#  likes      :integer          default(0)
#  bookmarks  :integer          default(0)
#  views      :integer          default(0)
#  created_at :datetime         not null
#  updated_at :datetime         not null
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
