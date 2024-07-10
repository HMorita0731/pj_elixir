defmodule Day6Workmob do
def read_csv(path \\ "132209_open_data_list.csv") do
  File.read!(path)
end

def csv_decode(str) do
[header | values] =
str
|> String.split("\r\n")


fields = String.split(header, ",")

for value <- values do
value
|> String.split(",")
|> then(fn list -> Enum.zip(fields, list) end )
|> Enum.into(%{})
end
end

def csv_decode!(path \\ "132209_open_data_list.csv") do
  path
  |> File.stream!()
  |> CSV.decode!(headers: true)
  |> Enum.to_list()
end

def json_encode!(data, path \\ "new.json") do
  data
  |>Jason.encode!()
  |>then(fn str -> File.write!(path, str) end)
end

def csv_encode(data, path \\"sample.csv") do
  data
  |> CSV.encode(headers: true)
  |> Enum.to_list()
  |> Enum.join()
  |> then(fn str -> File.write!(path, str) end)
end



end
