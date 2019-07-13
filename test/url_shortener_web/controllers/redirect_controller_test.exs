defmodule UrlShortenerWeb.RedirectControllerTest do
  use UrlShortenerWeb.ConnCase

  alias UrlShortener.ShortUrl

  @create_attrs %{
    long: "https://reddit.com/r/elixir",
    short: "ex-reddit"
  }

  def fixture(:link) do
    {:ok, link} = ShortUrl.create_link(@create_attrs)
    link
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "get redirect" do
    setup [:create_link]

    test "Redirects to the long url when provided the short url", %{conn: conn, link: link} do
      conn = get(conn, Routes.redirect_path(conn, :show, link.short))

      assert redirected_to(conn) == @create_attrs.long
    end

    test "Sends an error if the short url is not in the application", %{conn: conn} do
      assert_error_sent 404, fn ->
        get(conn, Routes.redirect_path(conn, :show, "badshort"))
      end
    end
  end

  defp create_link(_) do
    link = fixture(:link)
    {:ok, link: link}
  end
end