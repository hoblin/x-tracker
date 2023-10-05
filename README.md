# X-Tracker

X-Tracker is an open-source platform aimed at bringing transparency to social media interactions, particularly on Twitter. It allows users to monitor and track the statistics of specific tweets, providing a visual representation of how tweets are performing over time.

## Features

- Real-time tracking of tweet metrics including:
  - Likes
  - Views
  - Retweets
  - Retweets with citation
  - Comments
  - Bookmarks
- User-friendly interface to add tweets to the tracking pool.
- Advanced charting experience with Highcharts, allowing users to zoom, scroll, select different periods, and see real-time updates.
- Tampermonkey script generation for users to run the tracker in their own browser and contribute to the data pool.
- Community-driven: Users can contribute by adding new tweets to the pool or by running the tracking script to gather data.

## Tech Stack

- Ruby on Rails
- Bulma for styling
- Highcharts for data visualization
- RSpec with FactoryBot for testing
- PostgreSQL as the database
- Hosted on Heroku

## Setup and Installation

1. Clone the repository:
```bash
git clone https://github.com/hoblin/x-tracker.git
cd x-tracker
```
2. Install dependencies:
```bash
bundle install
yarn install
```
3. Setup the database:
```bash
rails db:create db:migrate
```
4. Start the Rails server:
```bash
rails s
```
5. Open your browser and navigate to `http://localhost:3000`.

## Contribution

X-Tracker is an open-source project, and contributions are warmly welcomed. Whether you have suggestions, a bug report, or a feature request, feel free to open an issue or create a pull request.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
