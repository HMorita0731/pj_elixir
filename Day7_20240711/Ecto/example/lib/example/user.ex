defmodule Example.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :first_name, :string
    field :last_name, :string
    field :age, :integer
    field :email, :string

    timestamps()
  end

  def changeset(user, params\\%{}) do
    user
    |> cast(params, [:first_name, :last_name, :age, :email])
    |> validate_required(:first_name, message: "Please enter your first name.")
    |> validate_required(:last_name, message: "Please enter your last name.")
    |> validate_email()
  end

  defp validate_email(cs) do
    cs
    |> validate_required(:email,message: "Please enter your email.")
    |> unique_constraint(:email,message: "Email has already been retrieved.")
    |> unsafe_validate_unique(:email, Example.Repo, message: "Email has already been retrieved.")
    |> validate_format(:email, ~r(^[^\s]+@[^\s]+$),message: "Must include the @ symbol, do not include spaces.")
  end
end
