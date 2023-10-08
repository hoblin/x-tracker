class TweetsController < ApplicationController
  skip_forgery_protection only: %i[track receive_metrics]  # Skip CSRF protection for Tampermonkey POST requests
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
  rescue ActiveRecord::RecordNotFound
    record_not_found
  end

  def receive_metrics
    tweet = Tweet.find_by(uuid: tweet_params[:uuid])
    return render json: {error: "Tweet not found"}, status: :not_found unless tweet

    tweet.tweet_metrics.create!(metrics_params.merge(user: tweet.user))

    tweet.update!(body: tweet_params[:body]) if tweet_params[:body].present?

    if tweet.body.blank?
      render json: {command: :fetch_tweet_details}
    else
      render json: {message: :ok}
    end
  end

  # render js template using headers expected by Tampermonkey to install it
  def track
    @tweet = Tweet.find(params[:id]).decorate
    @report_url = receive_metrics_url

    # TODO: replace with cancancan
    return record_not_found unless user_signed_in? && current_user == @tweet.user

    respond_to do |format|
      format.js { render layout: false, content_type: "application/javascript" }
    end
  end

  private

  def tweet_params
    params.require(:tweet).permit(:uuid, :body)
  end

  def metrics_params
    params.require(:metrics).permit(:likes, :reposts, :replies, :bookmarks, :views)
  end
end
