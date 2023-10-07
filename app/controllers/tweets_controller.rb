class TweetsController < ApplicationController
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
end
