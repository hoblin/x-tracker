# == Schema Information
#
# Table name: tweets
#
#  id         :bigint           not null, primary key
#  author     :string
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
require "rails_helper"

RSpec.describe Tweet, type: :model do
  let(:tweet) { create(:tweet) }
  let(:user) { create(:user) }

  describe "associations" do
    it "belongs to a user" do
      association = described_class.reflect_on_association(:user)
      expect(association.macro).to eq(:belongs_to)
    end

    it "has many tweet metrics" do
      association = described_class.reflect_on_association(:tweet_metrics)
      expect(association.macro).to eq(:has_many)
    end
  end

  describe "validations" do
    it "validates uniqueness of url" do
      new_tweet = Tweet.new(url: tweet.url)
      expect(new_tweet).to_not be_valid
      expect(new_tweet.errors.messages[:url]).to eq(["has already been taken"])
    end

    it "validates presence of url" do
      new_tweet = Tweet.new(url: nil)
      expect(new_tweet).to_not be_valid
      expect(new_tweet.errors.messages[:url]).to eq(["can't be blank"])
    end

    it "validates uniqueness of uuid" do
      new_tweet = Tweet.new(uuid: tweet.uuid)
      expect(new_tweet).to_not be_valid
      expect(new_tweet.errors.messages[:uuid]).to eq(["has already been taken"])
    end
  end

  describe "callbacks" do
    describe "#get_author" do
      it "sets the author from the url" do
        new_tweet = Tweet.new(url: "https://twitter.com/P_Kallioniemi/status/1674360288445964288", author: nil, user: user)
        expect(new_tweet).to be_valid
        expect(new_tweet.author).to eq("P_Kallioniemi")
      end
    end

    it "sets the uuid" do
      new_tweet = Tweet.create!(url: "https://twitter.com/P_Kallioniemi/status/1674360288445964288", uuid: nil, user: user)
      expect(new_tweet.uuid).not_to be_nil
    end
  end

  describe "instance methods" do
    describe "#author_url" do
      subject { tweet.author_url }

      it { is_expected.to eq("https://twitter.com/P_Kallioniemi") }
    end

    describe "#author_name" do
      subject { tweet.author_name }

      it { is_expected.to eq("@P_Kallioniemi") }
    end

    describe "metrics" do
      context "when there are no metrics" do
        describe "#likes" do
          subject { tweet.likes }

          it { is_expected.to be_nil }
        end

        describe "#reposts" do
          subject { tweet.reposts }

          it { is_expected.to be_nil }
        end

        describe "#replies" do
          subject { tweet.replies }

          it { is_expected.to be_nil }
        end

        describe "#bookmarks" do
          subject { tweet.bookmarks }

          it { is_expected.to be_nil }
        end

        describe "#views" do
          subject { tweet.views }

          it { is_expected.to be_nil }
        end
      end

      context "when there are metrics" do
        let!(:first_metric) { create(:tweet_metric, tweet: tweet, likes: 1, reposts: 2, replies: 3, bookmarks: 4, views: 5, created_at: 1.day.ago) }
        let!(:last_metric) { create(:tweet_metric, tweet: tweet, likes: 6, reposts: 7, replies: 8, bookmarks: 9, views: 10) }

        describe "#likes" do
          subject { tweet.likes }

          it { is_expected.to eq(6) }
        end

        describe "#reposts" do
          subject { tweet.reposts }

          it { is_expected.to eq(7) }
        end

        describe "#replies" do
          subject { tweet.replies }

          it { is_expected.to eq(8) }
        end

        describe "#bookmarks" do
          subject { tweet.bookmarks }

          it { is_expected.to eq(9) }
        end

        describe "#views" do
          subject { tweet.views }

          it { is_expected.to eq(10) }
        end
      end
    end
  end
end
