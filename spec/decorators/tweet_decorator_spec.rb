require "rails_helper"

RSpec.describe TweetDecorator do
  let(:tweet) { create(:tweet) }
  before { create_list(:tweet_metric, 10, tweet: tweet) }

  describe "#combined_chart" do
    it "returns a chart container" do
      expect(tweet.decorate.combined_chart).to include('id="chart-')
    end

    it "returns a likes chart" do
      expect(tweet.decorate.combined_chart).to include('"name":"Likes"')
    end

    it "returns a reposts chart" do
      expect(tweet.decorate.combined_chart).to include('"name":"Reposts"')
    end

    it "returns a replies chart" do
      expect(tweet.decorate.combined_chart).to include('"name":"Replies"')
    end

    it "returns a bookmarks chart" do
      expect(tweet.decorate.combined_chart).to include('"name":"Bookmarks"')
    end
  end

  describe "#likes_chart" do
    it "returns a chart container" do
      expect(tweet.decorate.likes_chart).to include('id="likes-chart"')
    end

    it "returns a likes chart" do
      expect(tweet.decorate.likes_chart).to include('"yAxis":{"title":{"text":"Likes"}}')
    end
  end

  describe "#replies_chart" do
    it "returns a chart container" do
      expect(tweet.decorate.replies_chart).to include('id="replies-chart"')
    end

    it "returns a replies chart" do
      expect(tweet.decorate.replies_chart).to include('"yAxis":{"title":{"text":"Replies"}}')
    end
  end

  describe "#reposts_chart" do
    it "returns a chart container" do
      expect(tweet.decorate.reposts_chart).to include('id="reposts-chart"')
    end

    it "returns a reposts chart" do
      expect(tweet.decorate.reposts_chart).to include('"yAxis":{"title":{"text":"Reposts"}}')
    end
  end

  describe "#bookmarks_chart" do
    it "returns a chart container" do
      expect(tweet.decorate.bookmarks_chart).to include('id="bookmarks-chart"')
    end

    it "returns a bookmarks chart" do
      expect(tweet.decorate.bookmarks_chart).to include('"yAxis":{"title":{"text":"Bookmarks"}}')
    end
  end

  describe "#views_chart" do
    it "returns a chart container" do
      expect(tweet.decorate.views_chart).to include('id="views-chart"')
    end

    it "returns a views chart" do
      expect(tweet.decorate.views_chart).to include('"yAxis":{"title":{"text":"Views"}}')
    end
  end
end
