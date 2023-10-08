class TweetsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:receive_metrics]  # Skip CSRF protection for this API endpoint
  caches_action :index, :show, expires_in: 15.minutes

  def index
    @tweets = Tweet.first(10).map(&:decorate)

    respond_to do |format|
      format.html # renders index.html.slim
    end
  end

  def show
    @tweet = Tweet.find(params[:id]).decorate

    respond_to do |format|
      format.html # renders show.html.slim
      format.json do
        # TODO: add filtering by date range and by metrics subset
        render json: @tweet.tweet_metrics.to_json
      end
    end
  end

  def receive_metrics
    tweet = Tweet.find_by(uuid: uuid_param)
    return render json: {error: "Tweet not found"}, status: :not_found unless tweet

    tweet.tweet_metrics.create!(metrics_params.merge(user: tweet.user))

    tweet.update!(tweet_params) if tweet_params[:body].present?

    if tweet.body.blank?
      render json: {command: :fetch_tweet_details}
    else
      render json: {message: :ok}
    end
  end

  private

  def uuid_param
    params.require(:uuid)
  end

  def metrics_params
    params.permit(:likes, :reposts, :replies, :bookmarks, :views)
  end

  def tweet_params
    params.fetch(:tweet, {}).permit(:body)
  end
end
