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
class Tweet < ApplicationRecord
  has_many :tweet_metrics, dependent: :destroy
  belongs_to :user

  validates :url, presence: true, uniqueness: true, format: %r{https://(twitter|x).com/\w+/status/\d+}
  validates :uuid, presence: true, uniqueness: true

  before_validation :set_author, :set_uuid

  def author_avatar_url
    avatar
  end

  def author_url
    "https://twitter.com/#{author}"
  end

  def author_name
    "@#{author}"
  end

  def likes
    last_metric&.likes
  end

  def reposts
    last_metric&.reposts
  end

  def replies
    last_metric&.replies
  end

  # TODO: Add quotes to the tweet metrics
  # def quotes
  #   last_metric&.quotes
  # end

  def bookmarks
    last_metric&.bookmarks
  end

  def views
    last_metric&.views
  end

  def match_url
    url.sub(%r{https://(twitter|x).com}, "https://*").sub(/\?.*/, "*")
  end

  private

  def last_metric
    @last_metric ||= tweet_metrics.last
  end

  def set_author
    return unless valid_url?

    self.author = url&.split("/")&.fetch(3)
  end

  def set_uuid
    self.uuid = SecureRandom.uuid if uuid.blank?
  end

  def valid_url?
    # Ensure the valid tweet url: https://twitter.com/P_Kallioniemi/status/1674360288445964288
    url&.match?(%r{https://(twitter|x).com/\w+/status/\d+})
  end
end
