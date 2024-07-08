defmodule Work3mob do
 def question05(str\\"Hi He Lied Because Boron Could Not Oxidize Fluorine. New Nations Might Also Sign
Peace Security Clause. Arthur King Can.") do

n = [1, 5, 6, 7, 8, 9, 15, 16, 19]

str2 = String.replace(str, ".", "")

~w(#{str2})
|> Enum.with_index(1)
|> Enum.map(fn {value, index} ->
  if index in n do
  %{String.at(value, 0) => index }
  else
  %{String.at(value, 0) <> String.at(value, 1) => index }
  end
  end)
 end

def question06(str\\"I am an NLPer") do
  words = String.split(str, " ")
  chars = String.codepoints(str)
  IO.puts("単語")
  IO.inspect(bi_gram(words))
  IO.puts("文字")
  IO.inspect(bi_gram(chars))

  :ok
end

defp bi_gram(list) do
  [_ | tail_list] = list
  Enum.zip(list, tail_list)
end

def question07(s1 \\ "paraparaparadise", s2 \\ "paragraph") do
#s1 = "paraparaparadise"

s1 = String.codepoints(s1)
s2 = String.codepoints(s2)
x = IO.inspect(bi_gram(s1), label: "x") |> MapSet.new
y = IO.inspect(bi_gram(s2), label: "y") |> MapSet.new


IO.inspect(MapSet.union(x, y), label: "和集合")
IO.inspect(MapSet.intersection(x, y), label: "積集合")
IO.inspect(MapSet.difference(x, y), label: "差集合")
IO.inspect(MapSet.subset?(MapSet.new([{"s", "e"}]), x), label: "xにseは含まれるか")
IO.inspect(MapSet.subset?(MapSet.new([{"s", "e"}]), y), label: "yにseは含まれるか")
:ok
end

def question08(x\\12,y\\"気温",z\\22.4) do
IO.puts("#{x}時の時#{y}は#{z}です。")
end

def question09(str\\"Hello, Elixir!") do
  String.codepoints(str)
  |> Enum.map(fn x ->
  if String.upcase(x) == x do
  x
  else
  <<y>> = x
  <<219 - y>>
  end
end)
|> Enum.join()
|> IO.puts()
end
end
