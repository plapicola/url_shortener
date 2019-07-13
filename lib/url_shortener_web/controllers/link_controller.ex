defmodule UrlShortenerWeb.LinkController do
  use UrlShortenerWeb, :controller

  alias UrlShortener.ShortUrl
  alias UrlShortener.ShortUrl.Link

  action_fallback UrlShortenerWeb.FallbackController

  def index(conn, _params) do
    links = ShortUrl.list_links()
    render(conn, "index.json", links: links)
  end

  def create(conn, %{"link" => link_params}) do
    with {:ok, %Link{} = link} <- ShortUrl.create_link(link_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.link_path(conn, :show, link))
      |> render("show.json", link: link)
    end
  end

  def show(conn, %{"id" => id}) do
    link = ShortUrl.get_link!(id)
    render(conn, "show.json", link: link)
  end

  def update(conn, %{"id" => id, "link" => link_params}) do
    link = ShortUrl.get_link!(id)

    with {:ok, %Link{} = link} <- ShortUrl.update_link(link, link_params) do
      render(conn, "show.json", link: link)
    end
  end

  def delete(conn, %{"id" => id}) do
    link = ShortUrl.get_link!(id)

    with {:ok, %Link{}} <- ShortUrl.delete_link(link) do
      send_resp(conn, :no_content, "")
    end
  end
end
