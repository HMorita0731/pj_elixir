defmodule EctoTransaction.PointLog do
  use Ecto.Schema
  import Ecto.Changeset

  schema "point_logs" do
    field :category, :string
    field :amount, :integer, default: 0
    field :point_balance, :integer, default: 0
    belongs_to :user, EctoTransaction.User
  end

  def changeset(point_log, params) do
    point_log
    |>cast(params, [:category, :amount, :point_balance, :user_id])
    |> validate_required(:category, message: "Plese enter your category")
    |> validate_inclusion(:category, ~w(give use), message: "Please enter
give or use.")
    |> validate_required(:amount, message: "Plese enter your amount")
    |> validate_required(:point_balance, message: "Plese enter your point_balance")

  end
end
