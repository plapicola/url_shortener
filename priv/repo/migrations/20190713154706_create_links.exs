defmodule UrlShortener.Repo.Migrations.CreateLinks do
  use Ecto.Migration

  def change do
    create table(:links) do
      add :long, :string
      add :short, :string

      timestamps()
    end

    create unique_index(:links, [:long])
    create unique_index(:links, [:short])
  end
end
