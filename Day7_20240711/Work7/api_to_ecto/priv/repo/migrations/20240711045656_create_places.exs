defmodule ApiToEcto.Repo.Migrations.CreatePlaces do
  use Ecto.Migration

  def change do
    create table(:places) do
    add :name, :string, null: false
    add :address, :string, null: false
    add :lat, :float, null: false
    add :lon, :float, null: false

    timestamps()
    end

  create unique_index(:places, [:name, :address], name:
  :places_name_address_index) #:nameとaddressに一意のindexを作成

  end
end
