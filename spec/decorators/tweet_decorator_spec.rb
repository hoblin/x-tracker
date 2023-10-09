require "rails_helper"

RSpec.describe TweetDecorator do
  let(:tweet) { create(:tweet, created_at: 1.hour.ago) }

  describe "#combined_chart" do
    before { create_list(:tweet_metric, 10, tweet: tweet) }

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

  describe "#status_tag" do
    context "when tracking is active" do
      let!(:tweet_metric) { create(:tweet_metric, tweet: tweet, created_at: 30.seconds.ago) }

      it "returns a status tag" do
        expect(tweet.decorate.status_tag).to include("tracking")
      end

      it "returns a status tag with the correct color" do
        expect(tweet.decorate.status_tag).to include("is-success")
      end

      it "returns a status tag with the correct time" do
        expect(tweet.decorate.status_tag).to include("1 minute")
      end
    end

    context "when tracking is inactivefor a 30 minutes" do
      let!(:tweet_metric) { create(:tweet_metric, tweet: tweet, created_at: 30.minutes.ago) }

      it "returns a status tag" do
        expect(tweet.decorate.status_tag).to include("delayed")
      end

      it "returns a status tag with the correct color" do
        expect(tweet.decorate.status_tag).to include("is-warning")
      end

      it "returns a status tag with the correct time" do
        expect(tweet.decorate.status_tag).to include("30 minutes")
      end
    end

    context "when tracking is inactive for more than a hour" do
      let!(:tweet_metric) { create(:tweet_metric, tweet: tweet, created_at: 61.minutes.ago) }

      it "returns a status tag" do
        expect(tweet.decorate.status_tag).to include("not tracking")
      end

      it "returns a status tag with the correct color" do
        expect(tweet.decorate.status_tag).to include("is-dark")
      end

      it "returns a status tag with the correct time" do
        expect(tweet.decorate.status_tag).to include("about 1 hour")
      end
    end

    context "when tracking never started" do
      it "returns a status tag" do
        expect(tweet.decorate.status_tag).to include("never tracked")
      end

      it "returns a status tag with the correct color" do
        expect(tweet.decorate.status_tag).to include("is-danger")
      end

      it "returns a status tag with the correct time" do
        expect(tweet.decorate.status_tag).to include("about 1 hour")
      end
    end
  end
end
