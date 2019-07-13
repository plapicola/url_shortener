defmodule UrlShortenerWeb.RedirectController do
  use UrlShortenerWeb, :controller

  alias UrlShortener.ShortUrl

  def show(conn, %{"short_url" => short_url}) do
    redirect(conn, external: ShortUrl.get_redirect_url!(short_url))
  end
end