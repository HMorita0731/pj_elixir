defmodule ApiToEcto.Place do
    use Ecto.Schema
    import Ecto.Changeset

    schema "places" do
        field :name, :string
        field :address, :string
        field :lat, :float
        field :lon, :float

        timestamps()

        end

def changeset(place, params \\ %{}) do
    place
    |> cast(params, [:name, :address, :lat, :lon])
    |> validate_required([:address, :lat, :lon])
    |> validate_name()
end

defp validate_name(cs) do
    cs
    |> validate_required(:name, message: "Please enter your name.")
    |> unique_constraint([:name, :address], message: "Name and address have alreadey been retrieved.")
    |> unsafe_validate_unique([:name, :address], ApiToEcto.Repo, message: "Name and address have alreadey been retrieved.")
end



end
