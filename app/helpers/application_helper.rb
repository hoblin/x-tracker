module ApplicationHelper
  def title(title)
    content_for(:title) { title }
  end

  def tweet_title(tweet)
    title("Tracking Tweet by #{tweet.author_name}: #{tweet.body&.truncate(50)}")
  end
end
