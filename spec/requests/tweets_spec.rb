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
