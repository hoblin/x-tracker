class TweetDecorator < Draper::Decorator
  delegate_all

  # CHARTS
  def combined_chart
    h.area_chart combined_metrics_series, height: "40vh", curve: false, library: chart_options
  end

  def likes_chart
    h.line_chart(
      likes_metric[:data],
      id: "likes-chart",
      min: min_y(likes_metric),
      max: max_y(likes_metric),
      height: "60vh",
      curve: false,
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
      curve: false,
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
      curve: false,
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
      curve: false,
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
      curve: false,
      library: single_metric_chart_options("Views")
    )
  end

  # <- CHARTS

  def status_tag
    last_metric_time = object.tweet_metrics.order(created_at: :desc).first&.created_at
    case last_metric_time
    when nil
      render_status_tag("never tracked", :danger, object.created_at)
    when 5.minutes.ago..Time.current
      render_status_tag("tracking", :success, last_metric_time)
    when 1.hour.ago..5.minutes.ago
      render_status_tag("delayed", :warning, last_metric_time)
    else
      render_status_tag("not tracking", :dark, last_metric_time)
    end
  end

  private

  def render_status_tag(status, style, time)
    h.content_tag :div, class: "tags has-addons" do
      [
        h.content_tag(:span, status, class: "tag is-#{style}"),
        h.content_tag(:span, h.time_ago_in_words(time), class: "tag is-# is-light")
      ].join.html_safe
    end
  end

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
      single_metric(:likes, resolution),
      single_metric(:replies, resolution),
      single_metric(:reposts, resolution),
      single_metric(:bookmarks, resolution)
      # views_metric TODO: enable after getting rid of chartkick and switching to custom Y axis
    ]
  end

  def resolution
    # resolution is 1 minute if we don't have many metrics and gradually increases up to 1 hour depending on the number of metrics
    @resolution ||= object.tweet_metrics.count / 2000 + 1
  end

  def caped_resolution(cap)
    [resolution, cap].min
  end

  def single_metric(metric, minutes = nil)
    minutes ||= caped_resolution(5)
    instance_variable_get("@#{metric}_metric") || instance_variable_set("@#{metric}_metric", {
      name: metric.capitalize,
      data: object.tweet_metrics.group_by_minute(:created_at, series: false, n: minutes).maximum(metric)
    })
  end

  def likes_metric
    single_metric(:likes)
  end

  def replies_metric
    single_metric(:replies)
  end

  def reposts_metric
    single_metric(:reposts)
  end

  def bookmarks_metric
    single_metric(:bookmarks)
  end

  def views_metric
    single_metric(:views)
  end
end
