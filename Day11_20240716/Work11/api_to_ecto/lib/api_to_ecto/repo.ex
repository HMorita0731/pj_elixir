defmodule ApiToEcto.Repo do
  use Ecto.Repo,
    otp_app: :api_to_ecto, #接続情報をconfigから取得
    adapter: Ecto.Adapters.Postgres #使用DBの設定
end
