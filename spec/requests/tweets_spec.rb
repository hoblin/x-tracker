require 'rails_helper'

RSpec.describe "Tweets", type: :request do
  let!(:tweet) { create(:tweet) }

  describe "GET index" do
    subject { get "/tweets" }

    it "returns http success" do
      subject
      expect(response).to have_http_status(:success)
    end

    it "returns a list of tweets" do
      subject
      expect(response.body).to include(tweet.author)
    end
  end

  describe "GET show" do
    subject { get "/tweets/#{tweet.id}" }

    it "returns http success" do
      subject
      expect(response).to have_http_status(:success)
    end

    it "returns a tweet" do
      subject
      expect(response.body).to include(tweet.author)
    end
  end
end
