defmodule CounterAppWeb.CounterLive do
  use CounterAppWeb, :live_view

  def render(assigns) do

    ~H"""
    <h1>this is: <%= @value %></h1>
    <.button type="button" phx-click="dec">-</.button>
    <.button type="button" phx-click="inc">+</.button>
    """
  end


  #mountは必ず定義
  #必ず{:ok,socket}を返す
  def mount(_params, _session,socket) do
    {:ok,assign(socket,:value,0)}
  end

  #必ず{:noreply,socket}を返す
  def handle_event("dec",_params,socket) do
    socket = update(socket, :value, fn value -> value - 1 end)
    {:noreply,socket}
  end

  def handle_event("inc",_params,socket) do
    socket = update(socket, :value, fn value -> value + 1 end)
    {:noreply,socket}
  end

end
