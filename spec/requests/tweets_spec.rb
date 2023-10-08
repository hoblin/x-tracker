require "rails_helper"

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

  describe "POST /receive_metrics" do
    subject { post "/tweets/receive_metrics", params: params }

    let(:metric_params) { {likes: 11, reposts: 22, replies: 33, bookmarks: 44, views: 55} }
    let(:params) { {uuid: uuid}.merge(metric_params) }
    let(:uuid) { tweet.uuid }

    context "when the tweet exists" do
      it "creates a new tweet metric with the correct values" do
        expect { subject }.to change { TweetMetric.count }.by(1)
        expect(TweetMetric.last).to have_attributes(
          tweet: tweet,
          user: tweet.user,
          likes: 11,
          reposts: 22,
          replies: 33,
          bookmarks: 44,
          views: 55
        )
      end

      it "returns a success message" do
        subject
        expect(response.body).to eq({message: :ok}.to_json)
      end
    end

    context "when the tweet does not exist" do
      let(:uuid) { "non-existent-uuid" }

      it "returns an error message" do
        subject
        expect(response.body).to eq({error: "Tweet not found"}.to_json)
      end
    end

    context "when the tweet does not have a body" do
      let(:tweet) { create(:tweet, body: nil) }
      let(:uuid) { tweet.uuid }

      it "returns a fetch tweet details command" do
        subject
        expect(response.body).to eq({command: :fetch_tweet_details}.to_json)
      end

      context "when tracker sends a body" do
        let(:params) { {uuid: uuid, tweet: {body: "new body"}.merge(metric_params)} }

        it "updates the tweet body" do
          subject
          expect(tweet.reload.body).to eq("new body")
        end

        it "returns a success message" do
          subject
          expect(response.body).to eq({message: :ok}.to_json)
        end
      end
    end
  end

  # Test signup/login/logout since we don't have a separate controller for users
  describe "POST /users" do
    let(:user_params) { attributes_for(:user) }

    it "creates a new user" do
      expect {
        post "/users", params: {user: user_params}
      }.to change(User, :count).by(1)
    end
  end

  describe "POST /users/sign_in" do
    let(:user) { create(:user) }

    it "signs in a user" do
      post "/users/sign_in", params: {user: {username: user.username, password: user.password}}
      expect(response).to redirect_to(tweets_path)
    end
  end

  describe "DELETE /users/sign_out" do
    let(:user) { create(:user) }

    it "signs out a user" do
      sign_in user
      delete "/users/sign_out"
      expect(response).to redirect_to(root_path)
    end
  end
end
