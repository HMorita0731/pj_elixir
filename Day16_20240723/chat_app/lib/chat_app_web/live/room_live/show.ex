defmodule ChatAppWeb.RoomLive.Show do
  use ChatAppWeb, :live_view

  alias ChatApp.Rooms
  alias ChatApp.Accounts
  alias ChatApp.Rooms.Message

  # アクセス時にmount最初に呼び出される
  # 次にhandle_paramsが呼び出される
  # renderかテンプレートがレンダリングされてクライアントに渡す
  # websocketの接続
  # mountをもう一度呼び出し
  # handle_paramsを呼び出す
  @impl true
  def mount(_params, session, socket) do
    user = Accounts.get_user_by_session_token(session["user_token"])
    {:ok, assign(socket, :current_user, user)}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    socket =
      if room = Rooms.get_room(id, socket.assigns.current_user.id) do
        if connected?(socket)do
          subscribe(room)
        end

        socket
        |> assign(:page_title, room.room_name)
        |> assign(:room, room)
        |> assign(:messages, Rooms.list_messages(room.id))
        |> assign_form(Rooms.change_message(%Message{}))
      else
        socket
        |> put_flash(:error, "Not join room.")
        |> redirect(to: ~p"/rooms")
      end

    {:noreply, socket}
  end

  @impl true
  def handle_event("send_message", %{"message" => params}, socket) do
    # params = %{message => %{message => "first message"}}
    params =
      Map.merge(params, %{
        "user_id" => socket.assigns.current_user.id,
        "room_id" => socket.assigns.room.id
      })

    socket =
      case Rooms.create_message(params) do
        {:ok, message} ->
         broadcast(message, :send_message)

         assign_form(socket,Rooms.change_message(%Message{message: ""}))
        {:error, cs} ->
          assign_form(socket, cs)
      end

    {:noreply, socket}
  end

  @impl true
  def handle_info({:send_message,message},socket) do
    {:noreply,
    update(socket, :messages, fn messages -> List.insert_at(messages,-1,message) end)}
  end

  defp assign_form(socket, cs) do
    assign(socket, :message_form, to_form(cs))
  end

  defp page_title(:show), do: "Show Room"
  defp page_title(:edit), do: "Edit Room"

  defp subscribe(room) do
    Phoenix.PubSub.subscribe(ChatApp.PubSub,"room_#{room.id}")
  end

  defp broadcast(message, :send_message) do
    Phoenix.PubSub.broadcast(ChatApp.PubSub, "room_#{message.room_id}", {:send_message,message})
  end
end
