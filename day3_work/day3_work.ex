defmodule Day3Work do
  def question01(str \\ "stressed") do
    String.reverse(str)
    |> IO.puts()
  end

  def question02(str \\ "パタトクカシーー") do
    String.slice(str, 0..-1//2)
    |> IO.puts()
  end

  def question02another(str \\ "パタトクカシーー") do
    String.codepoints(str)
    |> Enum.with_index()
    # インデックスは0から
    |> Enum.filter(fn {_key, index} -> rem(index, 2) == 0 end)
    |> Enum.map(fn {key, _index} -> key end)
    |> Enum.join()
    |> IO.puts()
  end

  def question03(str1 \\ "パトカー", str2 \\ "タクシー") do
    list1 = String.graphemes(str1)
    list2 = String.graphemes(str2)

    Enum.zip(list1, list2)
    |> Enum.map(fn x -> Tuple.to_list(x) end)
    |> List.flatten()
    |> Enum.join()
    |> IO.puts()
  end

  def question04(
        str \\ "Now I need a drink, alcoholic of course, after the heavy lectures involving
quantum mechanics."
      ) do
    str = String.replace(str, [",", "."], "")

    ~w(#{str})
    |> Enum.map(fn x -> String.length(x) end)
  end

  def question05(
        str \\ "Hi He Lied Because Boron Could Not Oxidize Fluorine. New Nations Might Also Sign
Peace Security Clause. Arthur King Can."
      ) do
    n = [1, 5, 6, 7, 8, 9, 15, 16, 19]

    ~w(#{str})
    |> Enum.with_index(1)
    |> Enum.map(fn {x, index} ->
      if(index not in n) do
        %{String.slice(x, 0, 2) => index}
      else
        %{String.at(x, 0) => index}
      end
    end)
  end

  def question06(str \\ "I am an NLPer") do
    words = ~w{#{str}}
    chars = String.codepoints(str)
    IO.puts("単語")
    IO.inspect(bi_gram(words))
    IO.puts("文字")
    IO.inspect(bi_gram(chars))
  end

  defp bi_gram(list) do
    [_ | tail_list] = list
    Enum.zip(list, tail_list)
  end

  def question07(str1 \\"paraparaparadise",str2 \\ "paragraph") do
    list1 = String.codepoints(str1)
    list2 = String.codepoints(str2)
    IO.puts("x : ")
    x = bi_gram(list1)
    |> IO.inspect()
    IO.puts("y : ")
    y = bi_gram(list2)
    |> IO.inspect()
    map1 = MapSet.new(x)
    map2 = MapSet.new(y)
    IO.puts("和集合 : ")
    MapSet.union(map1,map2)
    |> IO.inspect()
    IO.puts("差集合 : ")
    MapSet.difference(map1,map2)
    |> IO.inspect()
    IO.puts("積集合 : ")
    MapSet.intersection(map1,map2)
    |>IO.inspect()
    se = MapSet.new([{"s","e"}])
    IO.puts("xにseは含まれているか : ")
    IO.inspect(MapSet.subset?(map1,se))
    IO.puts("yにseは含まれているか : ")
    IO.inspect(MapSet.subset?(map2,se))
  end
end
