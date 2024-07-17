defmodule Question1019 do
  def get_list(path \\ "popular-names.txt") do
    path
    |> File.stream!() #ファイルの読み込み
    |> CSV.decode(separator: ?\t, headers: false) #タブで区切る　ヘッダーなし
    |> Enum.to_list() #キーワードリスト化
    |> Enum.map(fn {_x, element} -> element end) #リスト化
  end

  def txt_list(path \\ "col1.txt") do
    path
    |> File.stream!() #ファイルの読み込み
    |> CSV.decode(separator: ?\n, headers: false) #改行で区切る　ヘッダーなし
    |> Enum.to_list() #キーワードリスト化
    |> Enum.map(fn {_x, element} -> element end) #リスト化
    |> List.flatten()
  end

def question10(path \\ "popular-names.txt") do
  path
  |> get_list()
  |> length()
end

def question11(path \\ "popular-names.txt") do
  path
  |> get_list() #リストのリスト状態
  |> Enum.map(fn x -> Enum.join(x, " ") end) #要素であるリストの各要素をスペース区切りでつなぐ
  |> Enum.join(" ") #リストの各要素をスペース区切りでつなぐ
end

def question12(path \\ "popular-names.txt") do
  list = get_list(path)
  col1 = Enum.map(list, fn x -> Enum.at(x, 0) <> "\n" end)
  col2 = Enum.map(list, fn x -> Enum.at(x, 1) <> "\n"end)
  File.write("col1.txt", col1)
  File.write("col2.txt", col2)
end

def question13(path1, path2) do
  txt_list1 = txt_list(path1) #関数txt_listを呼び出してリスト状態で取得
  txt_list2 = txt_list(path2)
  zip_list = Enum.zip(txt_list1, txt_list2) #タプルのリストで取得
  Enum.map(fn x -> Tuple_to_list(x) end) #ここで今日は一旦終了
end

def myquestion13(path1\\"col1.txt",path2\\"col2.txt") do
  txt_list1 = txt_list(path1)
  txt_list2 = txt_list(path2)
  zip_list = Enum.zip(txt_list1, txt_list2)
  Enum.map(fn x -> Enum.join(Tuple_to_list(x),"\t") end)
end

end
