defmodule UrlShortener.ShortUrl.Link do
  use Ecto.Schema
  import Ecto.Changeset

  schema "links" do
    field :long, :string
    field :short, :string
    field :count, :integer, default: 0

    timestamps()
  end

  @doc false
  def changeset(link, attrs) do
    link
    |> cast(attrs, [:long, :short])
    |> validate_required([:long, :short])
    |> unique_constraint(:long)
    |> unique_constraint(:short)
  end
end
