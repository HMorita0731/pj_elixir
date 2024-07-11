defmodule ApiToEcto do
alias ApiToEcto.Place

#Elixirで扱えるデータ構造に変える関数
  def api_request(end_point_api \\
  "https://api.data.metro.tokyo.lg.jp/v1/PublicFacility") do
  end_point_api
  |> HTTPoison.get!()
  |> Map.get(:body)
  |> Jason.decode!()
  |> hd()
  end

#取得したデータから該当するデータをApiToEcto.Place構造体に割り当てる関数
  def get_geographic_coordinate(map) do
    %Place{
        name: map["名称"]["表記"],
        address: map["住所"] ["表記"],
        lat: String.to_float(map["地理座標"] ["緯度"]),
        lon: String.to_float(map["地理座標"] ["経度"])
    }
  end

#listの要素すべてにget_geographic_coordinateを適用
def get_geographic_coordinates(list) do
    Enum.map(list, & get_geographic_coordinate/1)
end


end
