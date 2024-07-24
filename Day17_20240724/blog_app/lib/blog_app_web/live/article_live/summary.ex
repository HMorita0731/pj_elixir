defmodule BlogAppWeb.ArticleLive.Summary do
  use BlogAppWeb, :live_view

  alias BlogApp.Articles

  def render(assigns) do
    ~H"""
    <.header>
    Listing Articles
    </.header>
    <div :for={article <- @articles} class="mt-2">
    <a>
    <%= article.user.name %>
    </a>
    <.link href={~p"/articles/show/#{article}"}>
    <div><%= article.submit_date %></div>
    <h2><%=article.title %></h2>
    </.link>
    </div>

    """
  end

  def mount(_params,_session,socket) do
    socket =
      socket
      |> assign(:articles,Articles.list_articles())
      |> assign(:page_title, "blog")

      {:ok, socket}
  end
end
