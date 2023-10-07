require Rails.root.join("lib/tasks/tweet_metrics_importer")

namespace :import do
  desc "Import data from SQLite to Postgres"
  task sqlite_to_pg: :environment do
    Tasks::TweetMetricsImporter.import_from_sqlite
  end
end
