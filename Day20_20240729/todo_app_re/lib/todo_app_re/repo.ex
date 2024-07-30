defmodule TodoAppRe.Repo do
  use Ecto.Repo,
    otp_app: :todo_app_re,
    adapter: Ecto.Adapters.Postgres
end
