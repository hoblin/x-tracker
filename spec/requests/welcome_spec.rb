require "rails_helper"

RSpec.describe "Welcomes", type: :request do
  describe "GET /index" do
    subject { get "/" }

    it "returns http success" do
      subject
      expect(response).to have_http_status(:success)
    end

    it "renders the index template" do
      subject
      expect(response).to render_template(:index)
    end
  end
end
