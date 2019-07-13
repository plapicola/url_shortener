defmodule UrlShortenerWeb.Router do
  use UrlShortenerWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", UrlShortenerWeb do
    pipe_through :api
    resources "/links", LinkController
  end

  scope "/", UrlShortenerWeb do
    get "/:short_url", RedirectController, :show
    get "/:short_url/stats", StatsController, :show
  end
end
