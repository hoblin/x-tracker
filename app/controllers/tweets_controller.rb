class TweetsController < ApplicationController
  skip_forgery_protection only: %i[track receive_metrics]  # Skip CSRF protection for Tampermonkey POST requests
  caches_action :index, :show, expires_in: 5.minutes
  before_action :authenticate_user!, only: %i[new create track]

  def index
    scope = Tweet.joins(:tweet_metrics)
      .select("tweets.*, COUNT(tweet_metrics.id) AS metrics_count")
      .group("tweets.id")
      .order("metrics_count DESC")
    @tweets = scope.limit(10).map(&:decorate)
    @other_tweets = Tweet.order("created_at DESC").limit(400).map(&:decorate)
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

  def new
    @tweet = Tweet.new
  end

  def create
    @tweet = current_user.tweets.new(create_tweet_params)

    if @tweet.save
      expire_action action: :index
      redirect_to @tweet
    else
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@tweet, partial: "tweets/form", locals: {tweet: @tweet}) }
        format.html { render :new }
      end
    end
  end

  def receive_metrics
    tweet = Tweet.find_by(uuid: tweet_params[:uuid])
    return render json: {error: "Tweet not found"}, status: :not_found unless tweet

    tweet.tweet_metrics.create!(metrics_params.merge(user: tweet.user))

    tweet.update!(tweet_params.except(:uuid)) if tweet_params[:body].present?

    if tweet.tweet_metrics.count < 10
      expire_action action: :index
      expire_action action: :show, id: tweet.id
    end

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

  def create_tweet_params
    params.require(:tweet).permit(:url)
  end

  def tweet_params
    params.require(:tweet).permit(:uuid, :body, :avatar)
  end

  def metrics_params
    params.require(:metrics).permit(:likes, :reposts, :replies, :bookmarks, :views)
  end
end
