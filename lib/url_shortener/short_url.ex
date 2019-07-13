defmodule UrlShortener.ShortUrl do
  @moduledoc """
  The ShortUrl context.
  """

  import Ecto.Query, warn: false
  alias UrlShortener.Repo

  alias UrlShortener.ShortUrl.Link
  alias Cache.LinkCache
  alias Counter.AccessCounter

  @doc """
  Returns the list of links.

  ## Examples

      iex> list_links()
      [%Link{}, ...]

  """
  def list_links do
    Repo.all(Link)
  end

  @doc """
  Gets a single link.

  Raises `Ecto.NoResultsError` if the Link does not exist.

  ## Examples

      iex> get_link!(123)
      %Link{}

      iex> get_link!(456)
      ** (Ecto.NoResultsError)

  """
  def get_link!(id), do: Repo.get!(Link, id)

  def get_redirect_url!(short_url) do
    url = get_expanded_url!(short_url)
    increment_access_count(short_url)
    url
  end

  @doc """
  Gets the long url for a short link.

  Raises `Ecto.NoResultsError` id the link does not exist.

  ## Examples

      iex> get_expanded_url!("short")
      "https://google.com"

      iex> get_expanded_url!("badshort")
      ** (Ecto.NoResultsError)
  """
  def get_expanded_url!(short_url) do
    LinkCache.fetch(short_url, fn ->
      Repo.get_by!(Link, short: short_url).long
    end)
  end

  @doc """
  Gets the access count for a short link

  ## Examples

      iex> get_access_count("short")
      3


  """
  def get_access_count(short_url) do
    case AccessCounter.get_count(short_url) do
      {:not_found} -> 0
      {:found, result} -> result
    end
  end

  @doc """
  Increments the access count of a particular short_url

  ## Examples

      iex> increment_access_count("short")
      1

      iex> increment_access_count("short")
      2

  """
  def increment_access_count(short_url) do
    AccessCounter.increment_count(short_url)
  end

  @doc """
  Creates a link.

  ## Examples

      iex> create_link(%{field: value})
      {:ok, %Link{}}

      iex> create_link(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_link(attrs \\ %{}) do
    %Link{}
    |> Link.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a link.

  ## Examples

      iex> update_link(link, %{field: new_value})
      {:ok, %Link{}}

      iex> update_link(link, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_link(%Link{} = link, attrs) do
    link
    |> Link.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Link.

  ## Examples

      iex> delete_link(link)
      {:ok, %Link{}}

      iex> delete_link(link)
      {:error, %Ecto.Changeset{}}

  """
  def delete_link(%Link{} = link) do
    Repo.delete(link)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking link changes.

  ## Examples

      iex> change_link(link)
      %Ecto.Changeset{source: %Link{}}

  """
  def change_link(%Link{} = link) do
    Link.changeset(link, %{})
  end
end
