# == Schema Information
#
# Table name: tweets
#
#  id         :bigint           not null, primary key
#  author     :string
#  avatar     :string
#  body       :text
#  url        :string           not null
#  uuid       :uuid             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_tweets_on_uuid  (uuid) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
FactoryBot.define do
  factory :tweet do
    association :user

    author { "P_Kallioniemi" }
    body { "In today's #vatniksoup, I'll introduce a South African-American(!) businessman and social media figure, Elon Musk" }
    url { "https://twitter.com/P_Kallioniemi/status/1674360288445964288" }
    uuid { FFaker::Guid.guid }
  end
end
