class TweetDecorator < Draper::Decorator
  delegate_all

  def combined_chart
    h.area_chart combined_metrics_series, height: "40vh", library: chart_options
  end

  def likes_chart
    h.line_chart(
      likes_metric[:data],
      id: "likes-chart",
      min: min_y(likes_metric),
      max: max_y(likes_metric),
      height: "60vh",
      library: single_metric_chart_options("Likes")
    )
  end

  def replies_chart
    h.line_chart(
      replies_metric[:data],
      id: "replies-chart",
      min: min_y(replies_metric),
      max: max_y(replies_metric),
      height: "60vh",
      library: single_metric_chart_options("Replies")
    )
  end

  def reposts_chart
    h.line_chart(
      reposts_metric[:data],
      id: "reposts-chart",
      min: min_y(reposts_metric),
      max: max_y(reposts_metric),
      height: "60vh",
      library: single_metric_chart_options("Reposts")
    )
  end

  def bookmarks_chart
    h.line_chart(
      bookmarks_metric[:data],
      id: "bookmarks-chart",
      min: min_y(bookmarks_metric),
      max: max_y(bookmarks_metric),
      height: "60vh",
      library: single_metric_chart_options("Bookmarks")
    )
  end

  def views_chart
    h.line_chart(
      views_metric[:data],
      id: "views-chart",
      min: min_y(views_metric),
      max: max_y(views_metric),
      height: "60vh",
      library: single_metric_chart_options("Views")
    )
  end

  private

  def min_y(metric)
    metric[:data].min_by { |k, v| k.to_i }&.last
  end

  def max_y(metric)
    metric[:data].max_by { |k, v| k.to_i }&.last
  end

  def single_metric_chart_options(title)
    chart_options.merge(
      yAxis: {
        title: {
          text: title
        }
      }
    )
  end

  def chart_options
    {
      chart: {
        zoomType: "xy"
      },
      resetZoomButton: {
        theme: {
          display: "flex"
        }
      },
      boost: {
        useGPUTranslations: true,
        usePreAllocated: true
      },
      plotOptions: {
        series: {
          dataGrouping: {
            enabled: true
          }
        }
      }
    }
  end

  def combined_metrics_series
    [
      likes_metric,
      replies_metric,
      reposts_metric,
      bookmarks_metric
      # views_metric TODO: enable after getting rid of chartkick and switching to custom Y axis
    ]
  end

  def likes_metric
    @likes_metric ||= {name: "Likes", data: object.tweet_metrics.group_by_minute(:created_at, series: false, n: 5).maximum(:likes)}
  end

  def replies_metric
    @replies_metric ||= {name: "Replies", data: object.tweet_metrics.group_by_minute(:created_at, series: false, n: 5).maximum(:replies)}
  end

  def reposts_metric
    @reposts_metric ||= {name: "Reposts", data: object.tweet_metrics.group_by_minute(:created_at, series: false, n: 5).maximum(:reposts)}
  end

  def bookmarks_metric
    @bookmarks_metric ||= {name: "Bookmarks", data: object.tweet_metrics.group_by_minute(:created_at, series: false, n: 5).maximum(:bookmarks)}
  end

  def views_metric
    @views_metric ||= {name: "Views", data: object.tweet_metrics.group_by_minute(:created_at, series: false, n: 5).maximum(:views)}
  end
end
