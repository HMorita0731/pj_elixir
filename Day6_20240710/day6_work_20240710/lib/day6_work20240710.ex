defmodule Day6Work20240710 do
  def read_csv(csv) do
    File.stream!(csv) |> CSV.decode!(headers: true) |> Enum.to_list()
  end

  def outputJSON(data) do
    Jason.encode(data)
  end

  def data_conversion(csv \\"132209_open_data_list.csv") do
  end
end
|
