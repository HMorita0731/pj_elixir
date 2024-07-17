defmodule EctoTransaction.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create tabele(:users) do
      add :name, :string, null: false
      add :email, :string, null: false
    end

  end
end
