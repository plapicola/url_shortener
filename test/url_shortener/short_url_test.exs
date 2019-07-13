defmodule UrlShortener.ShortUrlTest do
  use UrlShortener.DataCase

  alias UrlShortener.ShortUrl

  describe "links" do
    alias UrlShortener.ShortUrl.Link

    @valid_attrs %{long: "some long", short: "some short"}
    @update_attrs %{long: "some updated long", short: "some updated short"}
    @invalid_attrs %{long: nil, short: nil}

    def link_fixture(attrs \\ %{}) do
      {:ok, link} =
        attrs
        |> Enum.into(@valid_attrs)
        |> ShortUrl.create_link()

      link
    end

    test "list_links/0 returns all links" do
      link = link_fixture()
      assert ShortUrl.list_links() == [link]
    end

    test "get_link!/1 returns the link with given id" do
      link = link_fixture()
      assert ShortUrl.get_link!(link.id) == link
    end

    test "get_expanded_url! returns the long url for the link" do
      link = link_fixture()
      assert ShortUrl.get_expanded_url!(link.short) == link.long
    end

    test "create_link/1 with valid data creates a link" do
      assert {:ok, %Link{} = link} = ShortUrl.create_link(@valid_attrs)
      assert link.long == "some long"
      assert link.short == "some short"
    end

    test "create_link/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = ShortUrl.create_link(@invalid_attrs)
    end

    test "update_link/2 with valid data updates the link" do
      link = link_fixture()
      assert {:ok, %Link{} = link} = ShortUrl.update_link(link, @update_attrs)
      assert link.long == "some updated long"
      assert link.short == "some updated short"
    end

    test "update_link/2 with invalid data returns error changeset" do
      link = link_fixture()
      assert {:error, %Ecto.Changeset{}} = ShortUrl.update_link(link, @invalid_attrs)
      assert link == ShortUrl.get_link!(link.id)
    end

    test "delete_link/1 deletes the link" do
      link = link_fixture()
      assert {:ok, %Link{}} = ShortUrl.delete_link(link)
      assert_raise Ecto.NoResultsError, fn -> ShortUrl.get_link!(link.id) end
    end

    test "change_link/1 returns a link changeset" do
      link = link_fixture()
      assert %Ecto.Changeset{} = ShortUrl.change_link(link)
    end
  end
end
