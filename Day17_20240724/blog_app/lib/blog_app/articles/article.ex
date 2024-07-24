defmodule BlogApp.Articles.Article do
  use Ecto.Schema
  import Ecto.Changeset

  alias BlogApp.Accounts.User

  # 0:下書き/1:公開/2:限定公開
  schema "articles" do
    field :status, :integer, default: 0
    field :title, :string
    field :body, :string
    field :submit_date, :date
    belongs_to(:user, User)

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(article, attrs) do
    article
    |> cast(attrs, [:title, :body, :status, :submit_date, :user_id])
    |> validate_required([:title, :body, :status, :submit_date])
  end
end
