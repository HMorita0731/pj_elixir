defmodule EctoTransaction.Core do
  alias EctoTransaction.{Repo, User, Point, PointLog,Item,GetItem}
  alias Ecto.Multi
  import Ecto.Query

  @initial_points 1000
  def create_user(params) do
    Multi.new()
    |> Multi.insert(:user, User.changeset(%User{},params))
    |> Multi.insert(:point, fn %{user: user} ->
      Point.changeset(%Point{}, %{user_id: user.id, point_balance: @initial_points}) end)
    |>Multi.insert(:point_log, fn %{user: user} ->
      PointLog.changeset(%PointLog{},%{user_id: user.id, category: "give",
      amount: @initial_points, point_balance: @initial_points}) end)
    |> Repo.transaction()
  end

  def buy_item(user_id, item_id) do
    user = Repo.get(User, user_id) |> Repo.preload(:point)
    item = Repo.get(Item, item_id)

    if user && item do
      Multi.new()
      |> Multi.insert(:get_item, %GetItem{user_id: user.id, item_id: item.id})
      |> Multi.update(:point, fn _ ->
        point_balance = user.point.point_balance - item.price
        Point.changeset(user.point, %{point_balance: point_balance})
      end)
      |> Multi.insert(:point_log, fn %{point: point} ->
        PointLog.changeset(%PointLog{}, %{user_id: user.id, category: "use",
        amount: item.price, point_balance: point.point_balance})
      end)
      |> Repo.transaction()
    end
  end

  def delete_user(user_id) do
    Multi.new()
    |> Multi.run(:user, fn repo, _ ->
      case repo.get(User, user_id) do
        nil -> {:error, :not_found}
        user -> {:ok, user}
      end
    end)
    |> Multi.delete(:point, fn %{user: user} ->
      Point
      |> where([p], p.user_id == ^user.id)
      |> Repo.one()
    end)
    |> Multi.delete_all(:point_logs, fn %{user: user} ->
      where(PointLog, [pl], pl.user_id == ^user.id)
    end)
    |> Multi.delete_all(:get_items, fn %{user: user} ->
      where(GetItem, [gi], gi.user_id == ^user.id)
    end)
    |> Multi.delete(:deleate_user,fn %{user: user} -> user end)
    |> Repo.transaction()
  end
end
