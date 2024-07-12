alias ApiToEcto.Repo


#"https://api.data.metro.tokyo.lg.jp/v1/PublicFacility"
#|>ApiToEcto.api_request()
#|>Enum.each(fn place ->
 # place
  #|> ApiToEcto.get_geographic_coordinate()
  #|> Repo.insert!()
#end
#)

"lat-lon.csv"
|> ApiToEcto.csv_decode!()
|> Enum.map(fn place ->
  place
  |> ApiToEcto.map_extract() #CSVデータをデコード、マップに変換
  |> ApiToEcto.Place.changeset() #バリデーション
  |> Repo.insert() #DBに登録
  end)
  #インデックスつけて全データ表示
|> Enum.with_index(1)
|> Enum.each(fn {result, index} ->
  IO.inspect(result, label: "result#{index}")end)
