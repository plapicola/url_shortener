defmodule UrlShortenerWeb.StatsView do
  use UrlShortenerWeb, :view

  alias __MODULE__

  def render("show.json", %{stats: stats}) do
    %{data: render_one(stats, StatsView, "stats.json")}
  end

  def render("stats.json", %{stats: stats}) do
    %{
      short: stats.short_url,
      long: stats.long_url,
      access_count: stats.access_count
    }
  end
end