defmodule EctoTransaction.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :name, :string
    field :email, :string
    has_one :point, EctoTransaction.Point
    has_many :point_logs, EctoTransaction.PointLog
  end

  def changeset(user,params) do
    user
    |> cast(params, [:name, :email])
    |> validate_required(:name, massege: "Please, enter your name.")
    |> validate_required(:email, massege: "Please, enter your email.")
  end
end
