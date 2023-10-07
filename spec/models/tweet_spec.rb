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
#
require "rails_helper"

RSpec.describe Tweet, type: :model do
  describe "validations" do
    it "validates uniqueness of url" do
      first_tweet = create(:tweet)
      tweet = Tweet.new(url: first_tweet.url)
      expect(tweet).to_not be_valid
      expect(tweet.errors.messages[:url]).to eq(["has already been taken"])
    end

    it "validates presence of url" do
      tweet = Tweet.new(url: nil)
      expect(tweet).to_not be_valid
      expect(tweet.errors.messages[:url]).to eq(["can't be blank"])
    end
  end

  describe "callbacks" do
    describe "#get_author" do
      it "sets the author from the url" do
        tweet = Tweet.new(url: "https://twitter.com/P_Kallioniemi/status/1674360288445964288", author: nil)
        expect(tweet).to be_valid
        expect(tweet.author).to eq("P_Kallioniemi")
      end
    end
  end
end
