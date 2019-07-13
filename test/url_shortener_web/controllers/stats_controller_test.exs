defmodule UrlShortenerWeb.StatsControllerTest do
  use UrlShortenerWeb.ConnCase

  alias UrlShortener.ShortUrl

  @create_attributes %{short: "hi", long: "https://google.com"}

  def fixture(:link) do
    {:ok, link} = ShortUrl.create_link(@create_attributes)
    link
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "Get link stats" do
    setup [:create_link]

    test "Returns the short and long URLs as well as the access count", %{conn: conn, link: link} do
      conn = get(conn, Routes.stats_path(conn, :show, link.short))

      assert json_response(conn, 200)["data"] == %{
        "short" => link.short,
        "long" => link.long,
        "access_count" => 0
      }
    end

    test "Redirects increment access count", %{conn: conn, link: link} do
      get(conn, Routes.redirect_path(conn, :show, link.short))
      get(conn, Routes.redirect_path(conn, :show, link.short))
      :timer.sleep 100
      conn = get(conn, Routes.stats_path(conn, :show, link.short))

      assert json_response(conn, 200)["data"]["access_count"] == 2
    end

    test "Returns a 404 if the short URL doesn't exist", %{conn: conn} do
      assert_error_sent 404, fn ->
        get(conn, Routes.stats_path(conn, :show, "badshort"))
      end
    end
  end

  defp create_link(_) do
    link = fixture(:link)
    {:ok, link: link}
  end
end