# == Schema Information
#
# Table name: users
#
#  id                  :bigint           not null, primary key
#  encrypted_password  :string           default(""), not null
#  remember_created_at :datetime
#  username            :string           default(""), not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
# Indexes
#
#  index_users_on_username  (username) UNIQUE
#
require "rails_helper"

RSpec.describe User, type: :model do
  describe "associations" do
    it "has many tweets" do
      association = described_class.reflect_on_association(:tweets)
      expect(association.macro).to eq(:has_many)
    end

    it "has many tweet metrics" do
      association = described_class.reflect_on_association(:tweet_metrics)
      expect(association.macro).to eq(:has_many)
    end
  end

  describe "validations" do
    it "validates uniqueness of username" do
      create(:user, username: "username")
      new_user = User.new(username: "username")
      expect(new_user).to_not be_valid
      expect(new_user.errors.messages[:username]).to eq(["has already been taken"])
    end

    it "validates presence of username" do
      new_user = User.new(username: nil)
      expect(new_user).to_not be_valid
      expect(new_user.errors.messages[:username]).to eq(["can't be blank"])
    end
  end

  describe "instance methods" do
    describe "#admin?" do
      it "returns true if the user is the admin" do
        admin_user = create(:user, username: Rails.application.credentials.admin_user.username, password: Rails.application.credentials.admin_user.password)
        expect(admin_user.admin?).to eq(true)
      end

      it "returns false if the user is not the admin" do
        user = create(:user)
        expect(user.admin?).to eq(false)
      end
    end
  end
end
