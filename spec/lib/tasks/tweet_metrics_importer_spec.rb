require "rails_helper"
require Rails.root.join("lib/tasks/tweet_metrics_importer")

RSpec.describe Tasks::TweetMetricsImporter do
  let!(:user) { create(:user) }
  let!(:tweet) { create(:tweet, id: 44) }
  let(:db_path) { "db/test-database.sqlite3" }
  let(:batch_size) { 10 }
  let(:sqlite_db) { SQLite3::Database.new(db_path) }
  let(:time) { Time.parse("2022-02-02 04:00:00") }

  around do |example|
    Timecop.freeze(Time.parse("2020-01-01 12:00:00")) do
      example.run
    end
  end

  before do
    sqlite_db.results_as_hash = true
  end

  describe ".import_from_sqlite" do
    subject { described_class.import_from_sqlite(db_path, batch_size) }

    it "calls import_batch with the first batch" do
      first_batch = sqlite_db.execute("SELECT * FROM likes ORDER BY id ASC LIMIT #{batch_size} OFFSET 0")

      allow(described_class).to receive(:import_batch).and_return(nil)
      expect(described_class).to receive(:import_batch).with(first_batch).and_return(nil)
      subject
    end

    it "calls import_batch 10 times" do
      expect(described_class).to receive(:import_batch).exactly(10).times.and_return(nil)
      subject
    end
  end

  describe ".import_batch" do
    subject { described_class.import_batch(batch) }

    before do
      allow(described_class).to receive(:tweet).and_return(tweet)
      allow(described_class).to receive(:transform_row).and_return({
        user_id: user.id,
        tweet_id: 44,
        likes: 42,
        created_at: time,
        updated_at: time
      })
    end

    let(:time) { Time.parse("2022-02-02 04:00:00") }
    let(:batch) do
      [
        {
          "count" => 42,
          "created_at" => time,
          "updated_at" => time
        }
      ]
    end

    context "with new records" do
      it "creates a new record" do
        expect { subject }.to change { TweetMetric.count }.by(1)
      end
    end

    context "with existing records" do
      context "with a different time" do
        before do
          create(:tweet_metric, tweet: tweet, user: user, likes: 42, created_at: time - 1.day, updated_at: time - 1.day)
        end

        it "creates a new record" do
          expect { subject }.to change { TweetMetric.count }.by(1)
        end
      end

      context "with the different likes" do
        let!(:existing_tweet_metric) { create(:tweet_metric, user: user, tweet: tweet, likes: 43, created_at: time, updated_at: time) }

        it "updates the existing record" do
          expect { subject }.to_not change { TweetMetric.count }
          expect(existing_tweet_metric.reload.likes).to eq(42)
        end
      end

      context "with the same time and likes" do
        before do
          create(:tweet_metric,
            user: user,
            tweet: tweet,
            likes: 42,
            created_at: time,
            updated_at: time)
        end

        it "does not create a new record" do
          expect { subject }.to_not change { TweetMetric.count }
        end
      end
    end
  end

  describe ".transform_row" do
    it "transforms a row" do
      row = {
        "count" => 42,
        "created_at" => time,
        "updated_at" => time
      }
      expect(described_class.transform_row(row)).to eq({
        user_id: user.id,
        tweet_id: 44,
        likes: 42,
        created_at: time,
        updated_at: time
      })
    end
  end

  describe "#tweet" do
    it "returns the first tweet" do
      create(:tweet, url: "https://twitter.com/blabla/status/1234567890")
      expect(described_class.tweet.id).to eq(44)
    end
  end
end
