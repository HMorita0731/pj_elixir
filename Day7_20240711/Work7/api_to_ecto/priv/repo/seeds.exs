alias ApiToEcto.Repo

"https://api.data.metro.tokyo.lg.jp/v1/PublicFacility"
|>ApiToEcto.api_request()
|>Enum.each(fn place ->
  place
  |> ApiToEcto.get_geographic_coordinate()
  |> Repo.insert!()
end
)
