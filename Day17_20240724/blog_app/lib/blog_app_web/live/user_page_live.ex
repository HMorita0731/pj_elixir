defmodule BlogAppWeb.UserPageLive do
  use BlogAppWeb, :live_view

  alias BlogApp.Accounts
  alias BlogApp.Articles

  def render(assigns) do
    ~H"""
    <div class="border-2 rounded-lg px-2 py-4">
      <div class="font-bold text-lg"><%= @user.name %></div>

      <div class="text-gray-600 text-xs"><%= @user.email %></div>

      <div class="whitespace-pre-wrap border-b py-2 pb-2"><%= @user.introduction %></div>

      <div class="my-2">Article Count : <%= @articles_count %></div>

      <div :if={@user.id == @current_user_id}>
        <.link
          href={~p"/users/settings"}
          class="bg-blue-400 hover:bg-blue-600 py-1 px-4
        text-center block w-1/5 mt-2 rounded-lg"
        >
          Edit Profile
        </.link>
      </div>
    </div>

    <div>
      <div class="flex gap-2 items-center border-b-2 my-2">
        <% base_tab_class = ~w(block rounded-t-lg px-2 text-xl)

        tab_class = fn
          action when @live_action == action -> ~w(bg-blue-400) # _ -> _action ->
          _ -> ~w(bg-blue-200 hover: bg-blue-400)
        end %>
        <.link href={~p"/users/profile/#{@user}"} class={[base_tab_class, tab_class.(:info)]}>
          Articles
        </.link>

        <.link
          :if={@user.id == @current_user_id}
          href={~p"/users/profile/#{@user}/draft"}
          class={[base_tab_class, tab_class.(:draft)]}
        >
          Draft
        </.link>
      </div>

      <div>
        <%= if length(@articles) > 0 do %>
          <div
            :for={article <- @articles}
            class="flex justify-between pb-2 border-b last:border-none cursor-pointer"
          >
            <div :if={@live_action == :info}>
              <.link href={~p"/users/profile/#{article.user_id}"}
              class ="hover:underline"
              >
                <%= article.user.name %>
              </.link>

              <.link href={~p"/articles/show/#{article}"}
              class = "text-xs text-gray-600">
                <div><%= article.submit_date %></div>

                <h2 class = "text-2xl font-bold my-2 hover:underline"><%= article.title %></h2>
              </.link>
            </div>

            <.link :if={@live_action == :draft} href={~p"/articles/#{article}/edit"}>
              <div
              class = "text-2xl font-bold my-2t hover:underline"
              ><%= article.title %></div>

              <div :if={article.body} class="trunscate">
                <%= article.body %>
              </div>
            </.link>

            <div :if={@live_action in [:info,:draft]}
            class ="relative">
              <div
                :if={@user.id == @current_user_id}
                phx-click="set_article_id"
                phx-value-article_id={article.id}
                class="border rounded w-min px-1 mt-2 border-gray-400"
              >
                ...
              </div>

              <div :if={article.id == @set_article_id}
              class="absolute right-0 border rounded_lg borader_gray300 mt-2 p-2">
                <.link href={~p"/articles/#{article}/edit"}>Edit</.link>
                <span phx-click="delete_article" phx-value-article_id={article.id}
                class="#border-b block px2">
                  Delete
                </span>
              </div>
            </div>
          </div>
        <% else %>
          <div class="text-xl font-bold mt-2">
            <%= case @live_action do
              :info -> "No articles."
              :draft -> "No draft articles."
            end %>
          </div>
        <% end %>
      </div>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def handle_params(%{"user_id" => user_id}, _uri, socket) do
    socket =
      socket
      |> assign(:user, Accounts.get_user!(user_id))
      |> apply_action(socket.assigns.live_action)
      |> assign(:set_article_id, nil)

    {:noreply, socket}
  end

  defp apply_action(socket, :info) do
    user = socket.assigns.user
    # ( => %User{} or nil)
    current_user = socket.assigns.current_user
    current_user_id = get_current_user_id(current_user)

    articles =
      Articles.list_articles_for_user(user.id, current_user_id)

    socket
    |> assign(:articles, articles)
    |> assign(:articles_count, Enum.count(articles))
    |> assign(:current_user_id, current_user_id)
    |> assign(:page_title, user.name)
  end

  defp apply_action(socket, :draft) do
    user = socket.assigns.user
    # ( => %User{} or nil)
    current_user = socket.assigns.current_user
    current_user_id = get_current_user_id(current_user)

    if user.id == current_user_id do
      articles_count =
        user.id
        |> Articles.list_articles_for_user(current_user_id)
        |> Enum.count()

      socket
      |> assign(
        :articles,
        Articles.list_draft_articles_for_user(current_user_id)
      )
      |> assign(:articles_count, articles_count)
      |> assign(:current_user_id, current_user_id)
      |> assign(:page_title, user.name <> "-draft")
    else
      redirect(socket, to: ~p"/users/profile/#{user}")
    end
  end

  def handle_event("set_article_id", %{"article_id" => article_id}, socket) do
    id =
      unless article_id == "#{socket.assigns.set_article_id}" do
        String.to_integer(article_id)
      end

    {:noreply, assign(socket, :set_article_id, id)}
  end

  def handle_event("delete_article", %{"article_id" => article_id}, socket) do
    socket =
      case Articles.delete_article(Articles.get_article!(article_id)) do
        {:ok, _article} ->
          assign_article_when_deleted(socket, socket.assigns.live_action)

        {:error, _cs} ->
          put_flash(socket, :error, "Could not article.")
      end

    {:noreply, socket}
  end

  defp assign_article_when_deleted(socket, :info) do
    articles =
      Articles.list_articles_for_user(
        socket.assigns.user.id,
        socket.assigns.current_user.id
      )

    socket
    |> assign(:articles, articles)
    |> assign(:articles_count, Enum.count(articles))
    |> put_flash(:info, "Article deleted successfully.")
  end

  defp assign_article_when_deleted(socket, :draft) do
    socket
    |> assign(:articles, Articles.list_draft_articles_for_user(socket.assigns.user.id))
    |> put_flash(:info, "Draft article deleted successfully.")
  end

  defp get_current_user_id(current_user) do
    Map.get(current_user || %{}, :id)
  end
end
