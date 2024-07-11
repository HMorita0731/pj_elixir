defmodule ApiToEcto.Place do
    use Ecto.Schema

    schema "places" do
        field :name, :string
        field :address, :string
        field :lat, :float
        field :lon, :float

        timestamps()

        end


end
