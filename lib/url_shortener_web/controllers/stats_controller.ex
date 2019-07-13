defmodule UrlShortenerWeb.StatsController do
  use UrlShortenerWeb, :controller

  alias UrlShortener.ShortUrl

  def show(conn, %{"short_url" => short_url}) do
    long_url = ShortUrl.get_expanded_url!(short_url)
    access_count = ShortUrl.get_access_count(short_url)
    
    render(conn, "show.json", stats: %{
      short_url: short_url, 
      long_url: long_url, 
      access_count: access_count
    })
  end
end