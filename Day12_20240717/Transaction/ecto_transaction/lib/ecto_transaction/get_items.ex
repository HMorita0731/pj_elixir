defmodule EctoTransaction.GetItem do
  use Ecto.Schema

  schema "get_items" do
    belongs_to :user, EctoTransacton.User
    belongs_to :item, EctoTransacton.Item

  end
end
