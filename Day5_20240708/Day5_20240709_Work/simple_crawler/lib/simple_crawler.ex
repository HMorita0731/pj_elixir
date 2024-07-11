defmodule SimpleCrawler do
 def get_url(url) do
  html = HTTPoison.get!(url)

  {:ok, document} = Floki.parse_document(html.body)
  domain = "https://thewaggletraining.github.io/"

  document
  |> Floki.find("a")
  |> Floki.attribute("href") #リンクアドレス取得
  |> Enum.filter(& String.starts_with?(&1, domain)) # ドメインが違うやつをはじく
 end

 def get_url_list(url_list) do
  url_list
  |> Enum.map(& get_url(&1)) #url_list（ex.topページ からとってきた各urlからurlを取得
  |> List.flatten()
 end

def get_page_text(url_list) do
  for url <- url_list do
    html = HTTPoison.get!(url) #返り値は構造体(キーとして”body”が存在)
    {:ok, document} = Floki.parse_document(html.body) #ページからbody部分を取得

    document
    |>Floki.find("body")
    |>Floki.text() #bodyの内容を取得
    |>String.replace([" ", "\n"], "") #空白、改行をなくす
  end
end

def check_url(url_list) do
  all_url = Enum.uniq(url_list ++ get_url_list(url_list))

  if all_url == url_list do
    all_url
  else
    check_url(all_url)
  end
end

def main(url) do #トップページ＋トップページから飛んだところのテキストだけ
  url_list = check_url([url])
  get_page_text(url_list)
end

end
