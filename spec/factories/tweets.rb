# == Schema Information
#
# Table name: tweets
#
#  id         :bigint           not null, primary key
#  author     :string
#  body       :text
#  url        :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :tweet do
    author { "P_Kallioniemi" }
    body { "In today's #vatniksoup, I'll introduce a South African-American(!) businessman and social media figure, Elon Musk" }
    url { "https://twitter.com/P_Kallioniemi/status/1674360288445964288" }
  end
end
