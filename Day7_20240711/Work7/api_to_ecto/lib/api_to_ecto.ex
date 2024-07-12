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

  #CSVを取り込んでデコードする関数
  def csv_decode!(path\\ "lat-lon.csv") do
    path
    |> File.stream!()
    |> CSV.decode!(headers: true)
    |> Enum.to_list()
  end

  def map_extract(map) do
    %Place{
      name: map["大字町丁目コード"],
      address: map["都道府県名"] <> map["市区町村名"] <> map["大字町丁目名"],
      lat: String.to_float(map["緯度"]),
      lon: String.to_float(map["経度"])
    }
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
