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
#  user_id    :bigint           not null
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Tweet < ApplicationRecord
  has_many :tweet_metrics, dependent: :destroy
  belongs_to :user

  validates :url, presence: true, uniqueness: true
  validates :uuid, presence: true, uniqueness: true

  before_validation :set_author, :set_uuid

  def author_avatar_url
    # TODO: Implement a way to get the avatar url from the tweet
    "https://pbs.twimg.com/profile_images/1678305940481753089/g751T5c__400x400.jpg"
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

  private

  def last_metric
    @last_metric ||= tweet_metrics.last
  end

  def set_author
    self.author = url&.split("/")&.fetch(3)
  end

  def set_uuid
    self.uuid = SecureRandom.uuid if uuid.blank?
  end
end
