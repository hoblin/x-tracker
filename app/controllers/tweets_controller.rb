class TweetsController < ApplicationController
  def index
    @tweets = Tweet.all

    respond_to do |format|
      format.html # renders index.html.slim
    end
  end

  def show
    @tweet = Tweet.find(params[:id])

    respond_to do |format|
      format.html # renders show.html.slim
      format.json do
        # TODO: add filtering by date range and by metrics subset
        render json: @tweet.tweet_metrics.to_json
      end
    end
  end
end
